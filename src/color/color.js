"use strict";

// provide dummy value outside Scriptable runtime, e.g. pulp test
function safeColor(colorName) {
    if(typeof(Color) !== "undefined") {
	return Color[colorName]();
    } else {
	return {
	    red: 0,
	    green: 0,
	    blue: 0,
	    alpha: 0
	};
    }
}

exports.black_Impl = safeColor('black');

exports.blue_Impl = safeColor('blue');

exports.brown_Impl = safeColor('brown');

exports.clear_Impl = safeColor('clear');

exports.cyan_Impl = safeColor('cyan');

exports.darkGray_Impl = safeColor('darkGray');

exports.gray_Impl = safeColor('gray');

exports.green_Impl = safeColor('green');

exports.lightGray_Impl = safeColor('lightGray');

exports.magenta_Impl = safeColor('magenta');

exports.orange_Impl = safeColor('orange');

exports.purple_Impl = safeColor('purple');

exports.red_Impl = safeColor('red');

exports.white_Impl = safeColor('white');

exports.yellow_Impl = safeColor('yellow');
