"use strict";

exports.argsText = args.plainTexts[0];

// function listOfButtons(buttons) {
//   if(Object.keys(buttons).length === 0) {
//     return [];
//   } else {
//     const list = listOfButtons(buttons["value1"]);
//     list.push(buttons["value0"]);
//     return list;
//   }
// }
//
// function addButtons(buttons, alert) {
//   return listOfButtons(buttons).reduce(function(acc, btn) {
//     acc.addAction(btn);
//     return acc;
//   }, alert);
// }
//
// function showAlert(pureAlert) {
//   const alert = new Alert();
//   if(pureAlert["message"] !== {}) {
//     alert.message = pureAlert["message"]["value0"]
//   }
//   if(pureAlert["title"] !== {}) {
//     alert.title = pureAlert["title"]["value0"]
//   }
//   addButtons(pureAlert["buttons"], alert);
//   return alert.presentAlert().then(function(actionIndex) {
//     return listOfButtons(pureAlert["buttons"])[actionIndex];
//   });
// }
//
// exports.presentAlertImpl = function(pureAlert) {
//   return function() {
//     // return function(foo) {
//       return showAlert(pureAlert);
//     // }
//   }
// }

function listOfButtons(buttons) {
  if(Object.keys(buttons).length === 0) {
    return [];
  } else {
    const list = listOfButtons(buttons["value1"]);
    list.push(buttons["value0"]);
    return list;
  }
}

function addButtons(btnType, buttons, alert) {
  return listOfButtons(buttons).reduce(function(acc, btn) {
    acc.addAction(btn);
    return acc;
  }, alert);
}

function showAlert(btnType, pureAlert) {
  const alert = new Alert();
  if(pureAlert["message"] !== {}) {
    alert.message = pureAlert["message"]["value0"]
  }
  if(pureAlert["title"] !== {}) {
    alert.title = pureAlert["title"]["value0"]
  }
  addButtons(btnType, pureAlert["btnLabels"], alert);
  return alert.presentAlert().then(function(actionIndex) {
    return listOfButtons(pureAlert["buttons"])[actionIndex];
  });
}

exports.presentAlertImpl = function(btnType) {
  return function(pureAlert) {
    return function() {
      return showAlert(btnType, pureAlert);
    }
  }
}

/**
  This is necessary because the Scriptable app does not have a defintion for setTimeout.
  If the timer is actuualy needed it will need to be polyfilled, somehow. Not sure how.
*/
exports.setTimeout = function(f, _) {
  f();
}