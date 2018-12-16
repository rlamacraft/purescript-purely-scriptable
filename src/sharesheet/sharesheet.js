"use strict";

exports.presentAndWaitImpl_single = function(activityItem) {
  return function() {
      return ShareSheet.presentAndWait([activityItem]);
  }
}
