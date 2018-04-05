#!/usr/bin/env node

const path = require('path');
const fs = require('fs-promise');
const program = require('commander');
const cheerio = require('cheerio');

program
  .option('-i, --input [input]', 'Specifies input dir (current dir by default)')
  .option('-o, --output [output]', 'Specifies output file ("./sprite.svg" by default)')
  .option('-v, --viewbox [viewbox]', 'Specifies viewBox attribute (parsed by default)')
  .option('-p, --prefix [prefix]', 'Specifies prefix for id attribute (none by default)')
  .option('-q, --quiet', 'Disable informative output')
  .parse(process.argv);

const SRC_FOLDER = program.input || '.';
const DEST_FILE = program.output || 'sprite.svg';
const ID_PREFIX = program.prefix || '';
const VIEWBOX = program.viewbox || null;
const QUIET = program.quiet || false;

const log = (message) => {
  if (!QUIET) console.log(message);
};

const getSvgElement = (content) => {
  const $ = cheerio.load(content);
  return $('svg').first();
};

const getViewbox = (content) => {
  return VIEWBOX || getSvgElement(content).attr('viewbox');
};

const getPreserveAspectRatio = (content) => {
  return getSvgElement(content).attr('preserveaspectratio');
};

const constructId = (fileName) => {
  return (ID_PREFIX + fileName).replace(' ', '-');
};

const constructAttributesString = (attributes) => {
  return Object.keys(attributes).reduce((acc, key) => {
    const value = attributes[key]
    return value
      ? `${acc} ${key}='${value}'`
      : acc;
  }, '');
};

const getSvgContent = (content) => {
  return getSvgElement(content).html();
};

const createSymbol = (content, attributes) => {
  return `<symbol ${constructAttributesString(attributes)}>
    ${getSvgContent(content)}
  </symbol>`;
};

const wrapFile = (fileName, content) => {
  const attributes = {
    viewBox: getViewbox(content),
    id: constructId(fileName),
    preserveAspectRatio: getPreserveAspectRatio(content)
  };

  log(`Processing ‘${fileName}’ (viewBox ‘${attributes.viewBox}’)…`);

  return createSymbol(content, attributes);
};

const processFile = (file) => {
  const filePath = path.resolve(SRC_FOLDER, file);
  const fileName = path.basename(file, path.extname(file));
  const wrapContent = wrapFile.bind(null, fileName);

  return fs.readFile(filePath, 'utf8').then(wrapContent);
};

const removeDestFile = () => {
  return fs.remove(DEST_FILE);
};

const readSrcFolder = (foo) => {
  return fs.readdir(SRC_FOLDER);
};

const processFiles = (files) => {
  const processedFiles = files
    .filter(filterFile)
    .map(processFile);

  return Promise.all(processedFiles);
};

const filterFile = (file) => {
  return path.extname(file) === '.svg';
};

const getSpriteContent = (contents) => {
  return '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" '
    + 'style="width: 0; height: 0; visibility: hidden; position: absolute;" aria-hidden="true">'
    + contents.join('')
    + '</svg>';
};

const writeDestFile = (content) => {
  return fs.writeFile(DEST_FILE, content, 'utf8');
};

const printFinish = () => {
  log(`File ‘${DEST_FILE}’ successfully generated.`);
};

const catchErrors = (err) => {
  throw err;
};

removeDestFile()
  .then(readSrcFolder)
  .then(processFiles)
  .then(getSpriteContent)
  .then(writeDestFile)
  .then(printFinish)
  .catch(catchErrors);
