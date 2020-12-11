let filename = require.resolve('./customsDeclarations.txt')
const fs = require('fs');
// sync file read operation, since we don't need to optimize for web. Split on double newline.
const customsFileData = fs.readFileSync(filename).toString().split(/\n{2,}/g);
// create array of 'count objects', which we will use for count operations
const countObjectArray = customsFileData.map(row => {
  // each row represents one person's answers
  const personAnswerArray = row.split('\n');
  let countObj = {
    peopleInGroup: personAnswerArray.length,
    answersAnyoneSelected: [],
    answersEveryoneSelected: []
  }
  // iterate through a person's answers, add all answers to answersAnyoneSelected array
  personAnswerArray.forEach((answerString, index) => {
    const answersArray = answerString.split('');
    countObj[`person_${index + 1}`] = {
      answers: answersArray,
      questionsAnswered: answerString.length
    }
    countObj.answersAnyoneSelected.push.apply(countObj.answersAnyoneSelected, answersArray);
  })
  // use Set to get unique answers from the whole group
  countObj.answersAnyoneSelected = [...new Set(countObj.answersAnyoneSelected)];
  // get unique answers count for summing
  countObj.answersAnyoneSelectedCount = countObj.answersAnyoneSelected.length;
  return countObj;
})

const getAnswersEveryoneSelected = () => {
  countObjectArray.forEach(countObj => {
    // use the array of answers everyone in group selected to compare against each person's answer set
    countObj.answersAnyoneSelected.forEach(answer => {
      // default to true and set to false if we don't find a match
      let allAnsweredYes = true
      for (key in countObj) {
        // check all person nested objects, and if answer from answersAnyoneSelected is not in person's answer array, set allAnsweredYes to false
        // third check of allAnsweredYes will skip subsequent matching answers - if there is one person who doesn't have matching answer, allAnsweredYes is false
        if (key.includes('person') && !countObj[key].answers.includes(answer) && allAnsweredYes) {
          allAnsweredYes = false;
        }
      }
      // if all people have answer in their answer array, they all selected it
      if (allAnsweredYes) {
        countObj.answersEveryoneSelected.push(answer)
      }
    })
    // get shared answers count for summing
    countObj.answersEveryoneSelectedCount = countObj.answersEveryoneSelected.length
  })
}

const getSumOfAnswersAnyoneSelected = () => {
  let totalSum = 0;
  countObjectArray.forEach(countObj => {
    totalSum += countObj.answersAnyoneSelectedCount
  })
  return totalSum;
}

const getSumOfAnswersEveryoneSelected = () => {
  getAnswersEveryoneSelected();
  let totalSum = 0;
  countObjectArray.forEach(countObj => {
    totalSum += countObj.answersEveryoneSelectedCount
  })
  return totalSum;
}

const sumOfAnswersAnyoneSelected = getSumOfAnswersAnyoneSelected();
const sumOfAnswersEveryoneSelected = getSumOfAnswersEveryoneSelected();

console.log("The total sum of answers anyone selected is:", sumOfAnswersAnyoneSelected)
console.log("The total sum of answers everyone selected is:", sumOfAnswersEveryoneSelected)