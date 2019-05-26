testing
isEqual: anObservation with: theLast
	(anObservation at: #value )size = (theLast at: #value) size
		ifFalse: [ ^ false ].
	(anObservation at: #value)
		with: (theLast at: #value)
		do: [ :item1 :item2 | 
			(super isEqual: item1 with: item2)
				ifFalse: [ ^ false ] ].
	^ true

	"
	^ (anObservation at: #unpack) = (theLast at: #unpack)"