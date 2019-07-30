testing
needsToObservation: context node: node
	context receiver class = insideObject
		ifFalse: [ ^ false ].
	(node receiver isKindOf: RBVariableNode)
		ifFalse: [ ^ false ].
	(self methodNodeFromNode: node) ifNil: [ ^ false ].	
	^ true