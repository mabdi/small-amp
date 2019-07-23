as yet unclassified
findObservationPoint: item id: id
	(item isKindOf: RBMessageNode)
		ifFalse: [ ^ false ].
	(item selector = #observe:name:id:
		and: [ (item arguments at: 3) value = id ])
		ifTrue: [ ^ true ].
	(item selector = #observeResult:receiver:selector:name:id:
		and: [ (item arguments at: 5) value = id ])
		ifTrue: [ ^ true ].
	^ false