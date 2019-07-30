initialization
initializeFor: aMethod observer: anObserver inside: anObject
	self initializeFor: aMethod.
	observer := anObserver.
	insideObject := anObject 