"use strict";

exports.openImpl = function() {
    return function(c) {
	const URL = new CallbackURL(c.target + "://x-callback-url/" + c.action);
	console.log(URL);
	console.log(c);
	return function() {
	    return Promise.reject("developing");
	}
    }
}
