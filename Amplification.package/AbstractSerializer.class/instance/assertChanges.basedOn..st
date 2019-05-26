private
assertChanges: anObservation basedOn: aMemory
	self serializers
		detect: [ :s | s myTag = (anObservation at: #type) ]
		ifFound: [ :s | 
			"^ s assertChanges: anObservation basedOn: aMemory ]"
			| theLast |
			theLast := s findLast: anObservation in: aMemory.
			anObservation at: #unpack put: (self unserialize: anObservation).
			theLast
				ifNotNil: [ theLast at: #unpack put: (self unserialize: theLast) ].
			(theLast isNil or: [ s isNotEqual: anObservation with: theLast ])
				ifTrue: [ ^ s assertGenerateFor: anObservation basedOn: theLast ]
				ifFalse: [ ^ {} ] ]