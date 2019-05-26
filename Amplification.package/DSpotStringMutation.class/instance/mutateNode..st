as yet unclassified
mutateNode: aNode
	| nodes |
	nodes := OrderedCollection new.
	nodes add: (RBLiteralValueNode value: '').
	nodes
		add: (RBLiteralValueNode value: (self updateRandom: aNode value)).
	nodes
		add: (RBLiteralValueNode value: (self insertRandom: aNode value)).
	nodes
		add: (RBLiteralValueNode value: (self removeRandom: aNode value)).
	nodes add: (RBLiteralValueNode value: self randomString).
	^ nodes