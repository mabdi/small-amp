as yet unclassified
stateCapture: anObject depth: anInt
	| result |
	anInt < 0
		ifTrue: [ ^ nil ].
	(anObject isKindOf: Collection)
		ifTrue: [ result := anObject
				collect: [ :item | self stateCapture: item depth: anInt - 1 ].
			^ result ].
	anObject isKindOf: Number