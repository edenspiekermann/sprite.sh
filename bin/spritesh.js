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
  if (VIEWBOX) return VIEWBOX;
  return getSvgElement(content).attr('viewbox');
};

const getPreserveAspectRatio = (content) => {
  return getSvgElement(content).attr('preserveaspectratio');
};

const getId = (fileName) => {
  return (ID_PREFIX + fileName).replace(' ', '-');
};

const getAttributesString = (attributes) => {
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

const getSymbol = (content, attributes) => {
  return `<symbol ${getAttributesString(attributes)}>
    ${getSvgContent(content)}
  </symbol>`;
};

const wrapFile = (content, fileName) => {
  const attributes = {
    viewBox: getViewbox(content),
    id: getId(fileName),
    preserveAspectRatio: getPreserveAspectRatio(content)
  };

  log(`Processing ‘${fileName}’ (viewBox ‘${attributes.viewBox}’)…`);

  return getSymbol(content, attributes);
};

const processFile = (file) => {
  const filePath = path.resolve(SRC_FOLDER, file);
  const fileExt = path.extname(file);
  const fileName = path.basename(file, fileExt);

  if (fileExt !== '.svg') return null;

  return fs.readFile(filePath, 'utf8')
    .then((content) => wrapFile(content, fileName));
};

const removeDestFile = () => {
  return fs.remove(DEST_FILE);
};

const readSrcFolder = (foo) => {
  return fs.readdir(SRC_FOLDER);
};

const processFiles = (files) => {
  return Promise.all(files.map(processFile));
};

const getSpriteContent = (contents) => {
  return '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="display:none">'
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
