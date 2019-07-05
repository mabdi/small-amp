testing
isEqualWith: theLast
	(dictionary at: #value) size = (theLast at: #value) size
		ifFalse: [ ^ false ].
	(dictionary at: #value)
		with: (theLast at: #value)
		do: [ :item1 :item2 | 
			((SerializerFactory getUnserializer: item1) isEqualWith: item2)
				ifFalse: [ ^ false ] ].
	^ true