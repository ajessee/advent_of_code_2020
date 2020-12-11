let filename = require.resolve('./customsDeclarations.txt')
const fs = require('fs');
const customsFileData = fs.readFileSync(filename).toString().split(/\n{2,}/g);

const countObjectArray = customsFileData.map(row => {
  let dataArray = row.split('\n');
  let infoObj = {
    peopleInGroup: dataArray.length,
    answersAnyoneSelected: [],
    answersEveryoneSelected: []
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

const getAnswersEveryoneSelected = () => {
  countObjectArray.forEach(infoObj => {
    infoObj.answersAnyoneSelected.forEach(answer => {
      let allAnsweredYes = true
      for (key in infoObj) {
        if (key.includes('person') && !infoObj[key].answers.includes(answer) && allAnsweredYes) {
          allAnsweredYes = false;
        }
      }
      if (allAnsweredYes) {
        infoObj.answersEveryoneSelected.push(answer)
      }
    })
    infoObj.answersEveryoneSelectedCount = infoObj.answersEveryoneSelected.length
  })
}

const getSumOfAnswersAnyoneSelected = () => {
  let totalSum = 0;
  countObjectArray.forEach(infoObj => {
    totalSum += infoObj.answersAnyoneSelectedCount
  })
  return totalSum;
}

const getSumOfAnswersEveryoneSelected = () => {
  getAnswersEveryoneSelected();
  let totalSum = 0;
  countObjectArray.forEach(infoObj => {
    totalSum += infoObj.answersEveryoneSelectedCount
  })
  return totalSum;
}

const sumOfAnswersAnyoneSelected = getSumOfAnswersAnyoneSelected();
const sumOfAnswersEveryoneSelected = getSumOfAnswersEveryoneSelected();

console.log("The total sum of answers anyone selected is:", sumOfAnswersAnyoneSelected)
console.log("The total sum of answers everyone selected is:", sumOfAnswersEveryoneSelected)