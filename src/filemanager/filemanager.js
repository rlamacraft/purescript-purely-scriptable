"use strict";

exports.documentsDirectory_Impl = function(fileManager) {
    return fileManager.documentsDirectory();
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

exports.fileExists_Impl = function(fileManagerName) {
    const fileManager = fileManagerFromName(fileManagerName);
    return function(filePath) {
	return fileManager.fileExists(filePath);
    }
}

exports.readString_Impl = function(fileManagerName) {
    const fileManager = fileManagerFromName(fileManagerName);
    return function(filePath) {
	return fileManager.readString(filePath);
    }
}

exports.writeString_Impl = function(fileManagerName) {
    const fileManager = fileManagerFromName(fileManagerName);
    return function(filePath) {
	return function(content) {
	    fileManager.writeString(filePath, content);
	}
    }
}
