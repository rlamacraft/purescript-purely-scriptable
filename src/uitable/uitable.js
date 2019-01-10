"use strict";

function presentAndReturnSelectedRows(matrix, rowData, selecting) {
    var selected = [];
    var table = new UITable();
    for(var i = 0; i < matrix.length; i++) {
	var row = new UITableRow();
	for(var j = 0; j < matrix[i].length; j++) {
	    var cell = UITableCell.text(matrix[i][j].value0.value0, matrix[i][j].value1.value0);
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
	return presentAndReturnSelectedRow(tableData.value1, [], "no");
    }
}
