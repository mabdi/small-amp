visiting
visitMessageNode: aMessageNode
	aMessageNode parent parent class = RBMethodNode
		ifTrue: [ targetNodes add: aMessageNode  ]