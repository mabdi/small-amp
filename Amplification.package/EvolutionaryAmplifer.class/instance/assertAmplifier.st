asserting
assertAmplifier
	^ assertAmplifier
		ifNil: [ assertAmplifier := ProxyingAssertAmplifier new ]