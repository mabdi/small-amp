as yet unclassified
observeResult: aResult receiver: aReceiver selector: aSelector name: aString id: anInt
	| serialized |
	serialized := SerializerFactory serialize: aResult.
	serialized at: #id put: anInt.
	serialized at: #name put: aString.
	serialized at: #equalReceiver put: (aReceiver == aResult).
	serialized
		at: #time
		put: (DateAndTime now - DateAndTime unixEpoch) asMilliSeconds.
	memory add: serialized