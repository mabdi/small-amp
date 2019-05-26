visiting
visitCascadeNode: aCascadeNode
	aCascadeNode parent parent class = RBMethodNode
		ifTrue: [ targetNodes add: aCascadeNode  ]