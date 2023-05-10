import { writeFileSync } from "node:fs";
import { join as pathJoin } from "node:path";

import { isStrNumeric, strStartsWithAnyOf } from "neves.js/dist/string.js";
import { parsePdfIntoTextArray } from "neves.js/dist/pdf2jsonUtils.js";

import PDFParser from "pdf2json";

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
  valueDate;
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
  return (
    // Next 2 columns are dates.
    (isStrNumeric(
      arraySlider.array[arraySlider.currentIndex + 1].split("/")[0]
    ) &&
      isStrNumeric(
        arraySlider.array[arraySlider.currentIndex + 2].split("/")[0]
      )) ||
    isTableEnd(arraySlider.array[arraySlider.currentIndex + 1])
  );
};

/** @param { ArraySlider } arraySlider */
const extractCombinedStatement = (arraySlider) => {
  const originalIndex = arraySlider.currentIndex;
  const searchSlider = new ArraySlider(arraySlider.array, originalIndex, null);

  let allMovements = [];

  let includesSimpleAccountMovements;
  // Simple account movements.
  while (true) {
    includesSimpleAccountMovements = searchSlider.moveToSearchString(
      "EXTRATO DE",
      arraySlider.array.length
    );

    if (!includesSimpleAccountMovements) {
      break;
    }

    // Move to after the columns.
    arraySlider.currentIndex = searchSlider.currentIndex + 12;
    allMovements = allMovements.concat(extractMovements(arraySlider, true));
    searchSlider.currentIndex = arraySlider.currentIndex;
  }

  // Go back.
  arraySlider.currentIndex = originalIndex;
  searchSlider.currentIndex = originalIndex;

  let includesCreditCardMovements;
  // Credit card movements.
  while (true) {
    searchSlider.moveToSearchString(
      "RESUMO DE MOVIMENTOS",
      arraySlider.array.length
    );
    includesCreditCardMovements = searchSlider.moveToSearchString(
      "SALDO EM DIVIDA A DATA DO EXTRATO ANTERIOR",
      arraySlider.array.length
    );

    if (!includesCreditCardMovements) {
      break;
    }

    // Move to after the columns.
    arraySlider.currentIndex = searchSlider.currentIndex + 11;
    allMovements = allMovements.concat(extractMovements(arraySlider, true));
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

    if (!includesCreditCardMovements) {
      arraySlider.setReturnData(allMovements);
      return arraySlider;
    }

    // Move to after the columns.
    arraySlider.currentIndex = searchSlider.currentIndex + 9;

    allMovements = allMovements.concat(
      extractMovements(arraySlider, false, false)
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
const extractMovements = (
  arraySlider,
  isCombined = false,
  isSimpleAccount = false
) => {
  if (!isCombined && isSimpleAccount) {
    throw new Error("isSimpleAccount only exists in combined statements");
  }

  const allMovements = [];

  /** @type { number } */
  let iCol;
  /** @type { string[] } */
  let currentRow;
  /** @type { AccountMovement } */
  let currentMovement;
  /** @type { string } */
  let currentText;

  for (
    ;
    arraySlider.currentIndex < arraySlider.array.length;
    ++arraySlider.currentIndex
  ) {
    if (isTableEnd(arraySlider.currentText)) {
      break;
    }

    currentRow = extractAndAdvanceNextRow(arraySlider);

    if (!currentRow) {
      break;
    }

    currentMovement = new AccountMovement();

    for (iCol = 0; iCol < currentRow.length; ++iCol) {
      currentText = currentRow[iCol];

      if (iCol === 0) {
        // TODO: add date conversion (e.g.: "3.01" -> "2023/03/01")
        currentMovement.movementDate = currentText;
      } else if (iCol === 1) {
        // TODO: add date conversion (e.g.: "3.01" -> "2023/03/01")
        currentMovement.valueDate = currentText;
      } else if (iCol === 2) {
        currentMovement.description = currentText;
      } else if (iCol === 3) {
        currentMovement.debit = currentText;
      } else if (iCol === 4) {
        currentMovement.network = currentText;
      }
    }

    allMovements.push(currentMovement);
    currentMovement = null;
  }

  return allMovements;
};

/**
 * Extracts the next row of movements, mutating arraySlider.currentIndex.
 *
 * @param { ArraySlider } arraySlider
 * */
const extractAndAdvanceNextRow = (arraySlider) => {
  let row = [];
  let currentText;

  let iCol = 0;
  for (
    iCol = 1;
    arraySlider.currentIndex < arraySlider.array.length;
    ++arraySlider.currentIndex, ++iCol
  ) {
    currentText = arraySlider.currentText;

    if (iCol === 1) {
      row.push(currentText);
    } else if (iCol === 2) {
      row.push(currentText);
    } else if (iCol === 3) {
      // This is a credit re-payment. Ignore.
      if (currentText.startsWith(">")) {
        row = null;
        row = [];
        iCol = 0;
        arraySlider.currentIndex += 1;
        continue;
      }

      row.push(currentText);
    } else if (iCol === 4) {
      row.push(currentText);
    } else if (iCol === 5 && isNextElementRowEnd(arraySlider)) {
      row.push(currentText);

      return row;
    } else {
      throw new Error("Unhandled!");
    }
  }
};

(function main(args) {
  const pdfParser = new PDFParser();

  pdfParser.on("pdfParser_dataError", (errData) =>
    console.error(errData.parserError)
  );

  pdfParser.on("pdfParser_dataReady", (_) => {
    const textsArray = parsePdfIntoTextArray(pdfParser);

    writeFileSync(pathJoin("data", "movements.txt"), textsArray.join("\n"), {
      encoding: "utf8",
    });

    let dataSlider = new ArraySlider(textsArray);
    const isCreditCardStatementOnly = isCreditCardStatementPdf(dataSlider);

    dataSlider = isCreditCardStatementOnly
      ? extractCreditCardStatement(dataSlider)
      : extractCombinedStatement(dataSlider);

    writeFileSync(
      pathJoin("data", "movements.json"),
      JSON.stringify(dataSlider.returnData, null, 2),
      {
        encoding: "utf8",
      }
    );
  });

  pdfParser.loadPDF("./data/EXT  AUTONOMO CARTAO (DOC 202300001).pdf");
  // pdfParser.loadPDF("./data/EXTRATO COMBINADO 2023003.pdf");
  // pdfParser.loadPDF("./data/EXTRATO COMBINADO 2023004.pdf");
})(process.argv);
