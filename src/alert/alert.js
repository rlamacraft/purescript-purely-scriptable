"use strict";

function purescriptListToJsArray(list) {
  if(Object.keys(list).length === 0) { // == {}
    return [];
  } else {
    const array = purescriptListToJsArray(list["value1"]);
    array.push(list["value0"]);
    return array;
  }
}

function addButtons(btnType, buttons, alert) {
  return purescriptListToJsArray(buttons).reduce(function(acc, btn) {
    acc.addAction(btn);
    return acc;
  }, alert);
}

function addTextFields(textFields, alert) {
  return purescriptListToJsArray(textFields).reduce(function(acc, tf) {
    acc.addTextField(tf["placeholder"], tf["text"]);
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
  addTextFields(purAlert["textFields"], alert);
  return alert.presentAlert().then(function(actionIndex) {
    return purescriptListToJsArray(pureAlert["buttons"])[actionIndex];
    //TODO: Also return values of text fields
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
  If the timer is actualy needed it will need to be polyfilled, somehow. Not sure how.
*/
exports.setTimeout = function(f, _) {
  f();
}
