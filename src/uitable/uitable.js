"use strict";

function tableFromMatrix(matrix) {
    var table = new UITable();
    for(var i = 0; i < matrix.length; i++) {
	var row = new UITableRow();
	for(var j = 0; i < matrix[i].length; j++) {
	    var cell = UITableCell.text(matrix[i][j].value0, matrix[i][j].value1);
	    row.addCell(cell);
	}
	table.addRow(row);
    }
    return table;
}

exports.present_Impl = function(tableData) {
    var table = tableFromMatrix(tableData.value1);
    return function() {	
	return table.present();
    }
}
