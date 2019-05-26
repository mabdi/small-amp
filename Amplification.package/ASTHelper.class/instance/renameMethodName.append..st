as yet unclassified
renameMethodName: aSourceCode append: aText
	| re first |
	re := RBParser parseMethod: aSourceCode.
	first := (re selector splitOn: $:) at: 1.
	re selector: ((re selector splitOn: $:) at: 1 put: first , aText).
	^ re