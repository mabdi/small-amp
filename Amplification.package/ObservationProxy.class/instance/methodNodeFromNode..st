as yet unclassified
methodNodeFromNode: node
	| mtd |
	mtd := nil.
	mtd := (node parent isKindOf: RBAssignmentNode)
		ifTrue: [ node parent parent parent ]
		ifFalse: [ node parent parent ].
	(mtd isKindOf: RBMethodNode )ifTrue: [ ^ mtd ] ifFalse: [ ^ nil ]