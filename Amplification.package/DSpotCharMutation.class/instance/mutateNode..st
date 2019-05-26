as yet unclassified
mutateNode: aNode
	| nodes |
	nodes := OrderedCollection new.
	nodes add: (RBLiteralValueNode value: Character null).
	nodes add: (RBLiteralValueNode value: Character cr).
	nodes add: (RBLiteralValueNode value: Character space).
	nodes
		add: (RBLiteralValueNode value: Character allByteCharacters atRandom).
	nodes add: (RBLiteralValueNode value: (Character value: aNode value asInteger + 1)).
	nodes add: (RBLiteralValueNode value: (Character value: aNode value asInteger - 1)).
	^ nodes