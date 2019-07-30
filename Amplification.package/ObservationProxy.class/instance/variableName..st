accessing
variableName: node
	(node parent isKindOf: RBAssignmentNode)
		ifTrue: [ ^ node variable name ]
		ifFalse: [ ^ #tmp ]