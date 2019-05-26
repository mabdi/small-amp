as yet unclassified
canHandle: aNode
	^ (aNode isKindOf: RBLiteralValueNode)
		and: [ aNode value isKindOf: self myType ]