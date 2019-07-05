as yet unclassified
unserialize: dictionary
	| rowCount columnCount matrix |
	rowCount := (dictionary at: #extra) at: #rowCount.
	columnCount := (dictionary at: #extra) at: #columnCount.
	matrix := Array2D rows: rowCount columns: columnCount.
	1 to: rowCount do: [ :row | 
		1 to: columnCount do: [ :column | 
			| i |
			i := matrix indexForRow: row andColumn: column.
			matrix
				at: row
				at: column
				put: (SerializerFactory unserialize: ((dictionary at: #value) at: i)) ] ].
	^ matrix