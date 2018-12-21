"use strict";

function present(activityItems) {
    ShareSheet.present(activityItems);
}

exports.presentImpl_single = function(activityItem) {
    return present([activityItem]);
}

exports.presentImpl_multiple = function(activityItems) {
    return present(activityItems);
}
