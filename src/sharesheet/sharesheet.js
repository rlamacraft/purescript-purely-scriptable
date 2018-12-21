"use strict";

function presentAndWait(activityItems) {
    return function() {
	ShareSheet.presentAndWait(activityItems);
    }
}

exports.presentAndWaitImpl_single = function(activityItem) {
    return presentAndWait([activityItem]);
}

exports.presentAndWaitImpl_multiple = function(activityItems) {
    return presentAndWait(activityItems);
}

function present(activityItems) {
    ShareSheet.present(activityItems);
}

exports.presentImpl_single = function(activityItem) {
    return present([activityItem]);
}

exports.presentImpl_multiple = function(activityItems) {
    return present(activityItems);
}
