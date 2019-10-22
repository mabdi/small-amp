Class {
	#name : #Observer,
	#superclass : #Object,
	#instVars : [
		'observations',
		'memory',
		'serializers'
	],
	#category : #'Amplification-Core'
}

{ #category : #'as yet unclassified' }
Observer >> ObservationOn: aSelector with: anArray in: aReceiver method: method [
	| result elapsedTime |
	[ elapsedTime := Time
		millisecondsToRun: [ result := aReceiver withArgs: anArray executeMethod: method ].
	self
		observe: aReceiver
		selector: aSelector
		args: anArray
		results: result
		time: elapsedTime.
	^ result ]
		on: Error
		do: [ :ex | 
			(self observeException: ex)
				ifTrue: [ ^ aReceiver ]
				ifFalse: [ ex signal ] ]
]

{ #category : #'as yet unclassified' }
Observer >> amplify: aMethod [
	
]

{ #category : #initialization }
Observer >> initialize [
	memory := OrderedCollection new
]

{ #category : #accessing }
Observer >> memory [ ^memory
]

{ #category : #'as yet unclassified' }
Observer >> observe: anObject name: aString id: anInt [
	| serialized |
	serialized := Dictionary new.
	aString first isUppercase
		ifFalse: [ serialized := SerializerFactory serialize: anObject ].
	serialized at: #id put: anInt.
	serialized at: #name put: aString.
	serialized
		at: #time
		put: (DateAndTime now - DateAndTime unixEpoch) asMilliSeconds.
	memory add: serialized
]

{ #category : #accessing }
Observer >> observeCall: aSelector reciever: aReceiver receiverName: aReceiverName variable: aVariable variableName: aVariableName id: anInt [
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
]

{ #category : #'as yet unclassified' }
Observer >> observeException: exception id: anInt [
	| serialized |
	exception ifNil: [ ^ self ].
	serialized := Dictionary new.
	serialized at: #exceptionClass put: exception class name.
	serialized at: #id put: anInt.
	serialized
		at: #time
		put: (DateAndTime now - DateAndTime unixEpoch) asMilliSeconds.
	memory add: serialized
]

{ #category : #'as yet unclassified' }
Observer >> observeResult: aResult receiver: aReceiver selector: aSelector name: aString id: anInt [
	| serialized |
	serialized := SerializerFactory serialize: aResult.
	serialized at: #id put: anInt.
	serialized at: #name put: aString.
	serialized at: #equalReceiver put: (aReceiver == aResult).
	serialized
		at: #time
		put: (DateAndTime now - DateAndTime unixEpoch) asMilliSeconds.
	memory add: serialized
]
