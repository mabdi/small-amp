testing
isEqual: anObservation with: theLast
	^ (self unserialize: anObservation) = (self unserialize: theLast)