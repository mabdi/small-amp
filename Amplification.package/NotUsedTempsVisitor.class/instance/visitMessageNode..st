visiting
visitMessageNode: aMessageNode
	aMessageNode receiver name = tmp_var
		ifTrue: [ used := true ].
		super visitMessageNode: aMessageNode