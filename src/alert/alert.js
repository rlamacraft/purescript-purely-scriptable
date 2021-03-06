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

function jsArrayToPurescriptList(array) {
    if(array.length === 0) {
	return {};
    } else {
	var head = array[0];
	var tail = array.slice(1);
	return {
	    value0: head,
	    value1: jsArrayToPurescriptList(tail)
	}
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
    const placeholder = tf.placeholder === {} ? "" : tf.placeholder.value0;
    const text = tf.placeholder === {} ? "" : tf.text.value0;
    acc.addTextField(placeholder, text);
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
  addTextFields(pureAlert["textFields"], alert);
  return alert.presentAlert().then(function(actionIndex) {
    var textFields = [];
    purescriptListToJsArray(pureAlert["textFields"]).forEach(function (_, i) {
      textFields.push(alert.textFieldValue(i));
    });
    return {
      value0: purescriptListToJsArray(pureAlert["buttons"])[actionIndex],
      value1: textFields
    }
  });
}

exports.presentAlertImpl = function(btnType) {
  return function(pureAlert) {
    return function() {
      return showAlert(btnType, pureAlert);
    }
  }
}
