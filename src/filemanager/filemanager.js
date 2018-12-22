"use strict";

exports.documentDirectory_Impl = function(fileManager) {
    return fileManager.documentDirectory();
}

exports.libraryDirectory_Impl = function(fileManager) {
    return fileManager.libraryDirectory();    
}

exports.temporaryDirectory_Impl = function(fileManager) {
    return fileManager.temporaryDirectory();
}

function fileManagerFromName(fileManagerName) {
    if(fileManagerName === "iCloud") {
	return FileManager.iCloud();
    } else if(fileManagerName === "local") {
	return FileManager.local();
    } else {
	throw new Error("Unknown FileManager: " + fileManagerName);
    }
}

exports.isDirectory_Impl = function(fileManagerName) {
    const fileManager = fileManagerFromName(fileManagerName);
    return function(path) {
	return fileManager.isDirectory(path);
    }
}

exports.listContents_Impl = function(fileManagerName) {
    const fileManager = fileManagerFromName(fileManagerName);
    return function(path) {
	return fileManager.listContents(path);
    }
}
