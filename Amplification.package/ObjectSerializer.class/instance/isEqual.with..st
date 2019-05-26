testing
isEqual: anObservation with: theLast
	(anObservation at: #class) = (theLast at: #class)
		ifFalse: [ ^ false ]
		ifTrue: [ ^ (anObservation at: #value) keys
				allSatisfy: [ :k | 
					super
						isEqual: ( ((anObservation at: #value) at: k))
						with: ( ((theLast at: #value) at: k)) ] ]