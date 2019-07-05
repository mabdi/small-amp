testing
isEqualWith: theLast
	(dictionary at: #class) = (theLast at: #class)
		ifFalse: [ ^ false ]
		ifTrue: [ ^ (dictionary at: #value) keys
				allSatisfy: [ :k | 
					(SerializerFactory getUnserializer: ((dictionary at: #value) at: k)) 
					
						isEqualWith: ((theLast at: #value) at: k) ] ]