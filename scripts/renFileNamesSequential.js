const path = require("node:path");
const process = require("process");
const { readdirSync, renameSync } = require("node:fs");

const getFileBasename = (filePath) => {
  return path.basename(filePath, path.extname(filePath));
};

(function main(args) {
  const currentDirPath = process.cwd();
  const fileNames = readdirSync(currentDirPath, {
    encoding: "utf-8",
    withFileTypes: true,
  })
    .filter((dirObj) => dirObj.isFile() == true)
    .map((dirObj) => dirObj.name);

  const prefix = args.length >= 3 ? args[2] : null;

  let i;
  for (i = 0; i < fileNames.length; ++i) {
    const thisFileName = fileNames[i];
    const originalFilePath = path.join(currentDirPath, thisFileName);

    let newFilePath = path.join(
      currentDirPath,
      (prefix == null ? getFileBasename(thisFileName) : prefix) +
        `-${i}${path.extname(thisFileName)}`
    );

    console.log(`'${originalFilePath}' > '${newFilePath}'`);

    renameSync(originalFilePath, newFilePath);
  }
})(process.argv);
