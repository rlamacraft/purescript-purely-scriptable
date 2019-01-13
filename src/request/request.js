"use strict";

function request(requestFuncName, url, method, body, headers) {
    var request = new Request(url);
    request.method = method;
    if(method === "POST") {
	request.body = body;
    }
    var h = headers.reduce(function(acc, thisHeader) {
	acc[thisHeader.value0] = thisHeader.value1;
	return acc;
    }, {});
    request.headers = h;
    return request[requestFuncName]();
}

exports.loadString_Impl = function(url) {
    return function(method) {
	return function(body) {
	    return function(headers) {
		return function() {
		    return request('loadString', url, method, body, headers);
		}
	    }
	}
    }
}

exports.loadJSON_Impl = function(url) {
    return function(method) {
	return function(body) {
	    return function(headers) {
		return function() {
		    return request('loadJSON', url, method, body, headers);
		}
	    }
	}
    }
}
