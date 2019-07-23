visiting
visitVariableNode: aVariableNode
	(aVariableNode name = tmp_var and: [ aVariableNode isRead ])
		ifTrue: [ used := true ].
	super visitVariableNode: aVariableNode