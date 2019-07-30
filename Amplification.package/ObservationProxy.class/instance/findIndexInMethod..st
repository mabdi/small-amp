as yet unclassified
findIndexInMethod: node
	
	(node parent isKindOf: RBAssignmentNode)
		ifTrue: [ ^ node parent parent statements indexOf: node parent ]
		ifFalse: [ ^ node parent statements indexOf: node ]