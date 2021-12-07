let filename = require.resolve('./handyHaversacks.txt')
const fs = require('fs');
// sync file read operation, since we don't need to optimize for web. Split on double newline.
const fileData = fs.readFileSync(filename).toString().split(/\n/g);
// create array of data 'infoObj's that will have containing bag as key, and value of child bag object that will have key/value of bag name and number of bags
/* 
  [{
    'bright gray': {
      'bright gold': 2,
      'dull lavender': 5
    }
  }]
*/



const dataArray = fileData.map(row => {
  // split into containing bag rule and child bag rules
  const rulesArray = row.split('bags contain');
  const childRulesArray = rulesArray[1].split(',');
  const bagKey = rulesArray[0].trim().replace(' ', '_');
  let infoObj = {}
  infoObj[bagKey] = {}
  // get number of bags and bag description
  const childRuleRegex = /(\d+)(?<=\d+)(.*)(?=bags|bag)/
  // create child bag nested object in info object
  childRulesArray.forEach(childRule => {
    let found = childRule.trim().match(childRuleRegex);
    let bagNumber, bagDescription;
    if (!found){
      bagNumber = 0;
      bagDescription = 'none';
    } else {
      bagNumber = parseInt(found[1].trim());
      bagDescription = found[2].trim().replace(' ', '_');
    }
    infoObj[bagKey][bagDescription] = bagNumber;
  })
  return infoObj;
});

// recursive function to find all bags that can contain shiny gold bag, and then all bags that can contain those bags. containerBagArray starts empty and then is passed through recursively
const findAllContainerBags = (dataArray, bagKey, containerBagArray) => {
  dataArray.forEach(infoObj => {
    let containingBagKey = Object.keys(infoObj)[0];
    let childBagsObj = infoObj[containingBagKey];
    for (childBagKey in childBagsObj) {
      if (childBagKey == bagKey) {
        if (!containerBagArray.includes(containingBagKey)) {
          containerBagArray.push(containingBagKey)
          // recurse
          findAllContainerBags(dataArray, containingBagKey, containerBagArray)
        }
      }
    }
  })
  return containerBagArray;
}

const createBagCountObj = (dataArray, bagKey, countObj) => {
  let infoObj = dataArray.filter(e => Object.keys(e)[0] == bagKey)[0];
  if (Object.entries(countObj).length === 0) {
    countObj[bagKey] = {}
  }
  if (infoObj) {
    for (childKey in infoObj[bagKey]) {
      if (childKey == 'none') {
        return countObj
      } else {
        if (countObj.hasOwnProperty(childKey)) {
          console.log('what')
        } else {
          countObj[bagKey][childKey] = {
            count: infoObj[bagKey][childKey]
          }
        }
      } 
      createBagCountObj(dataArray, childKey, countObj[bagKey])
    }
  }
  return countObj
}

const getChildBagCount = (countObj, countObj2) => {
  for (key in countObj) {
    if (key === 'count') {
      continue
    }
    if (countObj[key].hasOwnProperty('count')) {
      console.log(key)
      if (!countObj2.hasOwnProperty('countArray')) {
        countObj2.countArray = []
      }
      if (!Object.values(countObj[key]).find(val => typeof val === 'object')) {
        countObj2.count += countObj[key].count
        countObj2.countArray.push(countObj[key].count)
        let arrayLength = countObj2.countArray.length
        if (arrayLength > 1) {
          let spliceArray = [(arrayLength - 2), 2]
          let lastTwo = countObj2.countArray.splice(...spliceArray)
          countObj2.countArray.push(lastTwo.reduce((a,b) => a * b))
        } else {
          countObj2.count += countObj2.countArray[0]
          countObj2.countArray = []
        }
      } else {
        countObj2.count += countObj[key].count
        countObj2.countArray.push(countObj[key].count)
        getChildBagCount(countObj[key], countObj2)
      }
    } else {
      console.log(key)
      getChildBagCount(countObj[key], countObj2)
    }
  }
}

const buildPaths = (countObj, keyArray) => {
  let key = Object.keys(countObj).find(k => k !== 'count');
    if (countObj[key].hasOwnProperty('count')) {
      console.log(key)
      if (!Object.values(countObj[key]).find(val => typeof val === 'object')) {
        console.log('look at key array')
        if (typeof keyArray[0] == 'object' && keyArray[0].length) {
          let newArr = keyArray[0][0].split('.')
          newArr.splice(newArr.length - 1, 1, key)
          keyArray.unshift([newArr.join('.')])
        } else {
          keyArray[0] += `.${key}`
          let lastArr = keyArray.shift();
          keyArray.splice(0, 0, [lastArr]);
        }
        delete countObj[key]
        key = Object.keys(countObj).find(k => k !== 'count');
        buildPaths(countObj[key], keyArray)
      } else {
        if (typeof keyArray[0] == 'object' && keyArray[0].length) {
          keyArray.unshift(`shiny_gold.${key}`)
        } else {
          keyArray[0] += `.${key}`
        }
        buildPaths(countObj[key], keyArray)
      }
    } else {
      keyArray[0] = `${key}`
      buildPaths(countObj[key], keyArray)

  }
}

const getChildBagCount2 = (countObj, keyArray) => {
  let countObjKey;
  function digObj(path, obj) {
    return path.split('.').reduce(function (prev, curr) {
      return prev ? prev[curr] : null;
    }, obj || self);
  }
  if (!keyArray.length) {
    countObjKey = Object.keys(countObj)[0];
    keyArray.push(countObjKey)
  } else {
    countObjKey = digObj(keyArray.join('.'), countObj)
  }

  for (key in countObj) {
    if (key === 'count') {
      continue
    }
    
  }
}

const idArray = []

function func(countObj) {
  let childObjs = Object.values(countObj).find(val => typeof val === 'object')
  if (childObjs) {
    for (child in childObjs) {
      if (child == 'count') {
        idArray.push(countObj.count)
        continue
      }
      func(childObjs[child])
    }
  }else {
    console.log('this')
    idArray.push(countObj.count)
  }

}




let containerBagArray = findAllContainerBags(dataArray, 'shiny_gold', []);

let countObj = createBagCountObj(dataArray, 'shiny_gold', {});
let count = getChildBagCount(countObj, {count: 0})
let count2 = buildPaths(countObj, [])
// func(countObj)
console.log(`Number of bag colors that can eventually contain a shiny gold bag: ${containerBagArray.length}`);