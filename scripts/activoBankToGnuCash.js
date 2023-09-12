import { writeFileSync } from "node:fs";
import { log } from "node:console";
import { extname, join as pathJoin } from "node:path";

import {
  emptyString,
  spaceString,
  isStrNullOrWhiteSpace,
  isStrNumeric,
  strStartsWithAnyOf,
  isStrNullOrEmpty,
  toTitleCaseSentence,
} from "neves.js/dist/string.js";
import { parsePdfIntoTextArray } from "neves.js/dist/pdf2jsonUtils.js";

import PDFParser from "pdf2json";

// e.g: "2.01"
const isStrANumLeftPaddedWith1Digit = (str) => {
  return isStrNumeric(str) && str.split(".")[0]?.length === 1;
};

const isCorrectDateFormat = (str) => {
  return !isStrNullOrEmpty(str) && /\d{4}\/\d{2}\/\d{2}/.test(str);
};

const normalizeDate = (str) => {
  if (str.includes("/")) {
    // Already on the correct format.
    return str;
  }

  var splitDate = str.split(".");

  // e.g.: "3.01" -> "2023/03/01"
  return (
    // This will only work if the movements are extracted on the same year as the movements itself, which is my use case.
    new Date().getFullYear() +
    "/" +
    splitDate[0].padStart(2, "0") +
    "/" +
    splitDate[1].padStart(2, "0")
  );
};

class ArraySlider {
  #array;

  currentIndex = 0;
  #returnData;

  /**
   * @param { any[] } array
   * @param { number } currentIndex
   * @param { any } returnData
   */
  constructor(array, currentIndex = 0, returnData = null) {
    this.#array = array;

    this.currentIndex = currentIndex;
    this.#returnData = returnData;
  }

  get array() {
    return this.#array;
  }

  get returnData() {
    return this.#returnData;
  }

  setReturnData(data) {
    this.#returnData = null;
    this.#returnData = data;
  }

  get currentText() {
    return this.#array[this.currentIndex];
  }

  /**
   * Searches for { searchString } and mutates { arraySlider.currentIndex }.
   * If not found, it gets back to the point of origin.
   *
   * @param { string } searchString
   * @param { number } maxSliderSearchIndex
   * @returns { boolean }
   */
  moveToSearchString(searchString, maxSliderSearchIndex) {
    if (!maxSliderSearchIndex) {
      throw new Error("maxSliderSearchIndex is required");
    } else if (maxSliderSearchIndex > this.#array.length) {
      throw new Error("maxSliderSearchIndex index out of range");
    }

    const originalIndex = this.currentIndex;

    let wasFound = false;
    for (; this.currentIndex < maxSliderSearchIndex; ++this.currentIndex) {
      if (this.#array[this.currentIndex].includes(searchString)) {
        wasFound = true;
        break;
      }
    }

    if (!wasFound) {
      this.currentIndex = originalIndex;
    }

    return wasFound;
  }
}

class AccountMovement {
  movementDate;
  processingDate;
  description;
  network;
  debit;
  credit;
}

/** @param { ArraySlider } arraySlider */
const isCreditCardStatementPdf = (arraySlider) => {
  return arraySlider.moveToSearchString("EXTRATO VISA", 30);
};

/** @param { string } value */
const isTableEnd = (value) => {
  return strStartsWithAnyOf(
    value,
    "Banco ActivoBank, S.A.",
    "SALDO EM DIVIDA A DATA",
    "SALDO FINAL"
  );
};

/** @param { ArraySlider } arraySlider */
const isNextElementRowEnd = (arraySlider) => {
  let currentPlus1 = arraySlider.array[arraySlider.currentIndex + 1];
  let currentPlus2 = arraySlider.array[arraySlider.currentIndex + 2];

  if (isCorrectDateFormat(currentPlus1) && isCorrectDateFormat(currentPlus2)) {
    currentPlus1 = currentPlus1.split("/");
    currentPlus2 = currentPlus2.split("/");

    // TODO: Review this. Is it possible that a transaction takes place in one month and the bank processes it in the next? (e.g. day 31)
    // Execution and processing dates are in the same month.
    return currentPlus1[1] === currentPlus2[1];
  }

  currentPlus1 = currentPlus1.split(".");
  currentPlus2 = currentPlus2.split(".");

  return (
    // Next 2 columns are dates.
    (isStrANumLeftPaddedWith1Digit(currentPlus1[0]) &&
      isStrANumLeftPaddedWith1Digit(currentPlus2[0]) &&
      // TODO: Review this. Is it possible that a transaction takes place in one month and the bank processes it in the next? (e.g. day 31)
      // Execution and processing dates are in the same month.
      currentPlus1[0] === currentPlus2[0]) ||
    isTableEnd(arraySlider.array[arraySlider.currentIndex + 1])
  );
};

const isStrPaymentNetwork = (str) => {
  return !isStrNullOrWhiteSpace(str) && (str === "MB" || str === "VIS");
};

/** @param { ArraySlider } arraySlider */
const extractCombinedStatement = (arraySlider) => {
  const originalIndex = arraySlider.currentIndex;
  const searchSlider = new ArraySlider(arraySlider.array, originalIndex, null);

  let allMovements = [];

  // TODO: Support simple account movements.

  // Credit card movements.
  let includesCreditCardMovements;

  includesCreditCardMovements = searchSlider.moveToSearchString(
    "SALDO EM DIVIDA A DATA DO EXTRATO ANTERIOR",
    arraySlider.array.length
  );

  if (!includesCreditCardMovements) {
    arraySlider.setReturnData(allMovements);
    return arraySlider;
  }

  while (true) {
    includesCreditCardMovements = searchSlider.moveToSearchString(
      "CREDITO",
      arraySlider.array.length
    );

    if (!includesCreditCardMovements) {
      break;
    }

    searchSlider.currentIndex += 1;
    arraySlider.currentIndex = searchSlider.currentIndex;

    allMovements = allMovements.concat(
      extractCurrentPageMovements(arraySlider, true)
    );

    searchSlider.currentIndex = arraySlider.currentIndex;
  }

  arraySlider.setReturnData(allMovements);
  return arraySlider;
};

/** @param { ArraySlider } arraySlider */
const extractCreditCardStatement = (arraySlider) => {
  const originalIndex = arraySlider.currentIndex;
  const searchSlider = new ArraySlider(arraySlider.array, originalIndex, null);

  let allMovements = [];

  let includesCreditCardMovements;

  while (true) {
    includesCreditCardMovements = searchSlider.moveToSearchString(
      "DETALHE DOS MOVIMENTOS",
      arraySlider.array.length
    );

    // Move to after the columns.
    includesCreditCardMovements = searchSlider.moveToSearchString(
      "Crédito",
      arraySlider.array.length
    );

    if (!includesCreditCardMovements) {
      arraySlider.setReturnData(allMovements);
      return arraySlider;
    }

    searchSlider.currentIndex += 1;
    arraySlider.currentIndex = searchSlider.currentIndex;

    allMovements = allMovements.concat(
      extractCurrentPageMovements(arraySlider, false, false)
    );

    searchSlider.currentIndex = arraySlider.currentIndex;
  }
};

/**
 * Extracts all movements, mutating arraySlider.currentIndex.
 *
 * @param { ArraySlider } arraySlider
 * @param { boolean } isCombined
 * @param { boolean } isSimpleAccount
 */
const extractCurrentPageMovements = (
  arraySlider,
  isCombined = false,
  isSimpleAccount = false
) => {
  if (!isCombined && isSimpleAccount) {
    throw new Error("isSimpleAccount only exists in combined statements");
  }

  const allMovements = [];

  /** @type { string[] } */
  let currentRow;
  /** @type { AccountMovement } */
  let currentMovement;

  for (
    ;
    arraySlider.currentIndex < arraySlider.array.length;
    ++arraySlider.currentIndex
  ) {
    if (isTableEnd(arraySlider.currentText)) {
      break;
    }

    currentRow = extractAndAdvanceToNextRow(arraySlider);

    if (!currentRow) {
      continue;
    }

    currentMovement = new AccountMovement();

    currentMovement.movementDate = normalizeDate(currentRow[0]);
    currentMovement.processingDate = normalizeDate(currentRow[1]);

    currentMovement.description = "";
    let iCol = 2;
    while (
      !isStrPaymentNetwork(currentRow[iCol]) &&
      iCol < currentRow.length - 2
    ) {
      currentMovement.description +=
        (iCol !== 2 ? spaceString : emptyString) + currentRow[iCol];

      ++iCol;
    }

    currentMovement.description = toTitleCaseSentence(
      currentMovement.description
    );

    const beforeLast = currentRow[currentRow.length - 2];
    const last = currentRow[currentRow.length - 1];
    if (isStrPaymentNetwork(last)) {
      currentMovement.network = last;
      currentMovement.debit = beforeLast;
    } else if (isStrPaymentNetwork(beforeLast)) {
      currentMovement.network = beforeLast;
      currentMovement.debit = last;
    } else {
      currentMovement.network = null;
      currentMovement.debit = last;
    }

    allMovements.push(currentMovement);
    currentMovement = null;
    currentRow = null;
  }

  return allMovements;
};

/**
 * Extracts the next row of movements, mutating arraySlider.currentIndex.
 *
 * @param { ArraySlider } arraySlider
 * */
const extractAndAdvanceToNextRow = (arraySlider) => {
  let row = [];
  let currentText;

  let iCol = 0;
  for (
    iCol = 1;
    arraySlider.currentIndex < arraySlider.array.length;
    ++arraySlider.currentIndex, ++iCol
  ) {
    currentText = arraySlider.currentText;

    if (currentText.startsWith(">")) {
      // Also skip the credit value (we only want debits).
      ++arraySlider.currentIndex;
      return null;
    }

    row.push(currentText);

    if (isNextElementRowEnd(arraySlider)) {
      return row;
    }
  }
};

/** @param { ArraySlider } arraySlider */
const extractStatement = (arraySlider) => {
  return isCreditCardStatementPdf(arraySlider)
    ? extractCreditCardStatement(arraySlider)
    : extractCombinedStatement(arraySlider);
};

/**
 *
 * @param { AccountMovement[] } allMovements
 */
const jsonToGnuCashCsv = (allMovements) => {
  return ["Date,Deposit,Description"]
    .concat(
      allMovements.map(
        (move) =>
          `${move.movementDate},${
            move.debit > 0 ? `-${move.debit}` : move.credit
          },"${move.description}"`
      )
    )
    .join("\n");
};

(function main(args) {
  if (args.length < 3) {
    console.error("Arguments are invalid, the path is required.");

    return;
  } else if (extname(args[2]) !== ".pdf") {
    console.error("The file argument is invalid, the file must be a PDF.");

    return;
  }

  const pdfParser = new PDFParser();

  pdfParser.on("pdfParser_dataError", (errData) =>
    console.error(errData.parserError)
  );

  pdfParser.on("pdfParser_dataReady", (_) => {
    const textsArray = parsePdfIntoTextArray(pdfParser);

    let dataSlider = new ArraySlider(textsArray);
    dataSlider = extractStatement(dataSlider);

    const parsedCsv = jsonToGnuCashCsv(dataSlider.returnData);

    writeFileSync(pathJoin("data", "movements.csv"), parsedCsv, {
      encoding: "utf8",
    });

    log(parsedCsv);
  });

  pdfParser.loadPDF(args[2]);
})(process.argv);
