"use strict";

exports.presentAndWaitImpl = function(activityItems) {
  return function() {
      return await ShareSheet.presentAndWait(activityItems);
  }
}
