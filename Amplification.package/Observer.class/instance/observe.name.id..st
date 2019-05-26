as yet unclassified
observe: anObject name: aString id: anInt
	| serialized |
	
	serialized := AbstractSerializer serialize: anObject.
	serialized at: #id put: anInt.
	serialized at: #name put: aString.
	serialized
		at: #time
		put: (DateAndTime now - DateAndTime unixEpoch) asMilliSeconds.
	memory add: serialized