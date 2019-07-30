as yet unclassified
isObservationPoint: item
	(item isKindOf: RBMessageNode)
		ifFalse: [ ^ false ].
	item selector = #observe:name:id:
		ifTrue: [ ^ true ].
	item selector = #observeResult:receiver:selector:name:id:
		ifTrue: [ ^ true ].
	^ false