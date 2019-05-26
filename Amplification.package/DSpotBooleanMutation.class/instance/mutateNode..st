as yet unclassified
mutateNode: aNode
	| nodes |
	nodes := OrderedCollection new.
	nodes add: (RBLiteralValueNode value: aNode value not).
	^ nodes