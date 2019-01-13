"use strict";

function presentAndReturnSelectedRows(matrix, rowData, selecting) {
    var rowConfigKeys = ['cellSpacing', 'height', 'backgroundColor'];
    var selected = [];
    var table = new UITable();
    for(var i = 0; i < matrix.length; i++) {
	var rowConfig = matrix[i].value0;

	var row = new UITableRow();
	if(Object.keys(rowConfig['cellSpacing']).length > 0) {
	    row.cellSpacing = rowConfig['cellSpacing'];
	}
	if(Object.keys(rowConfig['height']).length > 0) {
	    row.height = rowConfig['height'];
	}
	if(Object.keys(rowConfig['backgroundColor']).length > 0) {
	    row.backgroundColor = new Color(rowConfig['backgroundColor'].value0.hex, rowConfig['backgroundColor'].value0.alpha);
	}
	
	var matrixRow = matrix[i].value1;
	for(var j = 0; j < matrixRow.length; j++) {
	    var cell = UITableCell.text(matrixRow[j].value0.value0, matrixRow[j].value1.value0);
	    row.addCell(cell);
	}

	if(selecting === "single" || selecting === "many") {	
	    row.onSelect = function(index) {
		selected.push(index);
	    }
	    if(selecting === "single") {
		row.dismissOnSelect = true;
	    }
	    if(selecting === "many") {
		row.dismissOnSelect = false;
	    }
	}
	
	table.addRow(row);
    }
    
    return table.present().then(function() {
	if(selecting === "many") {
	    return selected.map(function(index) {
		return rowData[index];
	    });
	}
	if(selecting === "single") {
	    return rowData[selected[0]];
	}
    });
}

exports.present_multiSelect_Impl = function(tableData) {
    return function(rowData) {
	return function() {
	    return presentAndReturnSelectedRows(tableData.value1, rowData, "many");
	}
    }
}

exports.present_singleSelect_Impl = function(tableData) {
    return function(rowData) {
	return function() {
	    return presentAndReturnSelectedRows(tableData.value1, rowData, "single");
	}
    }
}

exports.present_Impl = function(tableData) {
    return function() {
	return presentAndReturnSelectedRows(tableData.value1, [], "no");
    }
}
