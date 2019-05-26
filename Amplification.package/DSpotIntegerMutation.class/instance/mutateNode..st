as yet unclassified
mutateNode: aNode
	| nodes |
	nodes := OrderedCollection new.
	nodes add: (RBLiteralValueNode value: aNode value + 1).
	nodes add: (RBLiteralValueNode value: aNode value - 1).
	nodes add: (RBLiteralValueNode value: aNode value * 2).
	nodes add: (RBLiteralValueNode value: (aNode value / 2) asInteger).
	nodes add: (RBLiteralValueNode value: SmallInteger maxVal).
	nodes add: (RBLiteralValueNode value: SmallInteger minVal).
	nodes add: (RBLiteralValueNode value: 0).
	^ nodes