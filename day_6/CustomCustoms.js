let filename = require.resolve('./customsDeclarations.txt')
const fs = require('fs');
const customsFileData = fs.readFileSync(filename).toString().split(/\n{2,}/g);

const countObjectArray = customsFileData.map(row => {
  let dataArray = row.split('\n');
  let infoObj = {
    peopleInGroup: dataArray.length,
    answersAnyoneSelected: []
  }
  dataArray.forEach((answerString, index) => {
    let answersArray = answerString.split('');
    infoObj[`person_${index + 1}`] = {
      answers: answersArray,
      questionsAnswered: answerString.length
    }
    infoObj.answersAnyoneSelected.push.apply(infoObj.answersAnyoneSelected, answersArray);
  })
  infoObj.answersAnyoneSelected = [...new Set(infoObj.answersAnyoneSelected)];
  infoObj.answersAnyoneSelectedCount = infoObj.answersAnyoneSelected.length;
  return infoObj;
})

const getTotalCount = () => {
  let totalSum = 0;
  countObjectArray.forEach(obj => {
    totalSum += obj.answersAnyoneSelectedCount
  })
  return totalSum;
}

const totalSum = getTotalCount();

console.log("The total sum is:", totalSum)