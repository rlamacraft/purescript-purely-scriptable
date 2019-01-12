"use strict";

function presentAndReturnSelectedRows(matrix, rowData, selecting) {
    var rowConfigKeys = ['cellSpacing', 'height', 'backgroundColor'];
    var selected = [];
    var table = new UITable();
    for(var i = 0; i < matrix.length; i++) {
	var rowConfig = matrix[i].value0;
	var row = rowConfigKeys.reduce(function(row, key) {
	    if(rowConfig[key] !== {}) {
		row[key] = rowConfig[key].value0;
	    }
	    return row;
	}, new UITableRow());

	var row = new UITableRow();
	if(rowConfig['cellSpacing'] !== {}) {
	    row.cellSpacing = rowConfig['cellSpacing'];
	}
	if(rowConfig['height'] !== {}) {
	    row.height = rowConfig['height'];
	}
	if(rowConfig['backgroundColor'] !== {}) {
	    row.backgroundColor = new Color(rowConfig['backgroundColor'].hex, rowConfig['backgroundColor'].alpha);
	}
	
	var rowData = matrix[i].value1;
	for(var j = 0; j < rowData.length; j++) {
	    var cell = UITableCell.text(rowData[j].value0.value0, rowData[j].value1.value0);
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
