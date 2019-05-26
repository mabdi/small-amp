testing
isEqual: anObservation with: theLast
	self serializers
		detect: [ :s | s canUnSerialize: anObservation ]
		ifFound: [ :s | ^ s isEqual: anObservation with: theLast ]