import { writeFileSync, readFileSync, existsSync } from "fs";
import { dirname } from "path";

const getFilePathFromArgs = (args) => {
  if (args.length < 3) {
    console.error("Invalid arguments. The path is required.");

    return;
  } else if (!existsSync(args[2])) {
    console.error("The data file does not exist.");

    return;
  }

  return args[2];
};

(function main(args) {
  const filePath = getFilePathFromArgs(args);

  writeFileSync(
    `${dirname(filePath)}/outputFileLineLinesArray.json`,
    `[${readFileSync(filePath, "utf8")
      .split("\n")
      .map((line) => `"${line}"`)
      .join(", ")}]`,
    { encoding: "utf8" }
  );
})(process.argv);
