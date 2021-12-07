let filename = require.resolve('./fileName.txt')
const fs = require('fs');
// sync file read operation, since we don't need to optimize for web. Split on double newline.
const fileData = fs.readFileSync(filename).toString().split(/\n/g);

const dataArray = fileData.map(row => {
  // each row represents one person's answers
  const rowArray = row.split('\n');
  let infoObj = {
  }
});