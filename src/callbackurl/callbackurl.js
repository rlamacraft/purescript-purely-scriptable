"use strict";

exports.openImpl = function(c) {
    const url = c.parameters.reduce(function(acc, param) {
	acc.addParameter(param.value0, param.value1);
	return acc;
    }, new CallbackURL(c.target + "://x-callback-url/" + c.action));
    return function() {
	return url.open();
    }
}
