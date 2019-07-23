accessing
observeCall: aSelector reciever: aReceiver receiverName: aReceiverName variable: aVariable variableName: aVariableName id: anInt
	| serializer serialized |
	serializer := SerializerFactory getSerializer: aReceiver.
	serialized := serializer serialize: aReceiver.
	serialized at: #id put: anInt.
	serialized at: #name put: aReceiverName.
	serialized
		at: #time
		put: (DateAndTime now - DateAndTime unixEpoch) asMilliSeconds.
	(aVariable ~~ aReceiver and: [ serializer captureResult: aSelector ])
		ifTrue: [ serialized at: #resultName put: aVariableName.
			serialized
				at: #result
				put: (SerializerFactory serialize: aVariable) ].
	memory add: serialized