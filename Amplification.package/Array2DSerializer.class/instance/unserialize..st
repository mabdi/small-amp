as yet unclassified
unserialize: aDic
	| rowCount columnCount matrix |
	rowCount := (aDic at: #value) at: #rowCount.
	columnCount := (aDic at: #value) at: #columnCount.
	matrix := Array2D rows: rowCount columns: columnCount.
	1 to: rowCount
		do: [ :row | 
			1 to: columnCount
				do: [ :column | 
					| i |
					i := matrix indexForRow: row andColumn: column.
					matrix
						at: row
						at: column
						put: (AbstractSerializer unserialize: ((aDic at: #value) at: i)) ] ].
	^ matrix