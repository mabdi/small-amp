initialization
initializeFor: aMethod action: anAction
	method := aMethod.
	self installMethod: aMethod.
	action := anAction