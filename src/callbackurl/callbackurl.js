"use strict";

function PStoJScallbackURL(c) {
    return c.parameters.reduce(function(acc, param) {
	acc.addParameter(param.value0, param.value1);
	return acc;
    }, new CallbackURL(c.target + "://x-callback-url/" + c.action));
}

exports.open_Impl = function(c) {
    var url = PStoJScallbackURL(c);
    return function() {
	return url.open();
    }
}

exports.getURL_Impl = function(c) {
    var url = PStoJScallbackURL(c);
    return url.getURL();
}
