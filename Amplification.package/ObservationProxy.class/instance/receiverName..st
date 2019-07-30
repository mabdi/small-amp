as yet unclassified
receiverName: node
	(node parent isKindOf: RBAssignmentNode)
		ifTrue: [ ^ node value receiver name ]
		ifFalse: [ ^ node receiver name ]