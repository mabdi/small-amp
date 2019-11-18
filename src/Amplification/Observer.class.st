Class {
	#name : #Observer,
	#superclass : #Object,
	#instVars : [
		'observations',
		'memory',
		'serializers',
		'chekingFlaky',
		'flankyIdx',
		'flakyLen'
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

{ #category : #adding }
Observer >> addOrCheck: obj [
	chekingFlaky
		ifFalse: [ memory add: obj ]
		ifTrue: [ [ self checkFlaky: obj ]
				on: Exception
				do: [ :er | self halt ] ]
]

{ #category : #'as yet unclassified' }
Observer >> amplify: aMethod [
	
]

{ #category : #adding }
Observer >> checkFlaky: obj [
	| old |
	flankyIdx := flankyIdx + 1.
	old := memory at: flankyIdx.
	self checkFlaky: old with: obj path: {}
]

{ #category : #testing }
Observer >> checkFlaky: oldOne with: newOne path: apath [
	| oldVal newVal |
	
	oldVal := oldOne.
	newVal := newOne.
	apath
		do: [ :key | 
			oldVal := oldVal at: key.
			newVal := newVal at: key ].
	(oldVal at: #type ifAbsent: [ #ignore ]) = #object
		ifTrue: [ (oldVal at: #value) ifNotNil:[
				(oldVal at: #value) keysDo: [ :key | 
					| newPath |
					newPath := apath
						,
							{#value.
							key}.
					self checkFlaky: oldOne with: newOne path: newPath ] ]].
	(oldVal at: #type ifAbsent: [ #ignore ]) = #primitive
		ifTrue: [ ((oldVal at: #class) = (newVal at: #class)
				and: [ (oldVal at: #value) = (newVal at: #value) ])
				ifFalse: [ oldVal at: #flaky put: true ] ]
]

{ #category : #initialization }
Observer >> initialize [
	memory := OrderedCollection new.
	chekingFlaky := false
]

{ #category : #accessing }
Observer >> memory [ ^memory
]

{ #category : #'as yet unclassified' }
Observer >> observe: anObject name: aString id: anInt [
	| serialized doseialize |
	doseialize := true.
	aString = 'self'
		ifTrue: [ doseialize := false ].
	aString first isUppercase
		ifTrue: [ doseialize := false ].
	serialized := Dictionary new.
	doseialize
		ifTrue: [ serialized := SerializerFactory serialize: anObject ].
	serialized at: #id put: anInt.
	serialized at: #name put: aString.
	serialized
		at: #time
		put: (DateAndTime now - DateAndTime unixEpoch) asMilliSeconds.
	self addOrCheck: serialized
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
	self addOrCheck: serialized
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
	self addOrCheck: serialized
]

{ #category : #'as yet unclassified' }
Observer >> observeResult: aResult receiver: aReceiver selector: aSelector name: aString id: anInt [
	| serialized |
	serialized := SerializerFactory serialize: aResult.
	serialized at: #id put: anInt.
	serialized at: #name put: aString.
	serialized at: #equalReceiver put: aReceiver == aResult.
	serialized
		at: #time
		put: (DateAndTime now - DateAndTime unixEpoch) asMilliSeconds.
	self addOrCheck: serialized
]

{ #category : #'as yet unclassified' }
Observer >> observeTimeOut: duarationInMilliSeconds id: idx [
	| serialized |
	serialized := Dictionary new.
	serialized at: #timeOutLimit put: duarationInMilliSeconds.
	serialized at: #id put: idx.
	serialized
		at: #time
		put: (DateAndTime now - DateAndTime unixEpoch) asMilliSeconds.
	self addOrCheck: serialized
]

{ #category : #'as yet unclassified' }
Observer >> resetFlakyDetection [
	chekingFlaky := true.
	flankyIdx := 0
]
