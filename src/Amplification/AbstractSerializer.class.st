Class {
	#name : #AbstractSerializer,
	#superclass : #Object,
	#instVars : [
		'object',
		'dictionary'
	],
	#category : #'Amplification-Experiment'
}

{ #category : #asserting }
AbstractSerializer class >> assertClassName: aClassName name: aName [
	| assertStatement theObject theValue |
	aClassName isTestCase
		ifTrue: [ ^ {} ].
	theObject := RBMessageNode
		receiver: (RBVariableNode named: aName)
		selector: #class.
	theValue := RBVariableNode named: aClassName name.
	assertStatement := RBMessageNode
		receiver: (RBSelfNode named: 'self')
		selector: #assert:equals:description:
		arguments:
			{theObject.
			theValue.
			(RBLiteralValueNode value: 'smallAmp')}.
	^ {assertStatement}
]

{ #category : #private }
AbstractSerializer class >> canSerialize: anObject [
	^ self supportingTypes
		anySatisfy: [ :c | 
			
			anObject isKindOf: c ]
]

{ #category : #private }
AbstractSerializer class >> canUnSerialize: aDic [
	"^ self myTag = (aDic at: #type)"

	(aDic at: #value)
		ifNil: [ (aDic at: #class) = UndefinedObject
				ifFalse: [ ^ false ] ].
	^ self supportingTypes
		anySatisfy: [ :c | 
			(aDic at: #class) = c
				or: [ (aDic at: #class) allSuperclasses includes: c ] ]
]

{ #category : #asserting }
AbstractSerializer class >> makeAssertName: aString value: anObject last: theLast [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
AbstractSerializer class >> makeAssertTimeOut: timeOut [
	| assertStatement theMessage theTimeOut theDiscription |
	theMessage := RBVariableNode named: 'fake'.
	theTimeOut := RBMessageNode
		receiver: (RBVariableNode named: 'Duration')
		selector: #milliSeconds:
		arguments: {(RBLiteralValueNode value: timeOut)}.
	theDiscription := RBLiteralValueNode value: 'smallAmp'.
	assertStatement := RBMessageNode
		receiver: (RBSelfNode named: 'self')
		selector: #should:takeMoreThan:description:
		arguments:
			{theMessage.
			theTimeOut.
			theDiscription}.
	^ assertStatement
]

{ #category : #'as yet unclassified' }
AbstractSerializer class >> myTag [
	self subclassResponsibility
]

{ #category : #private }
AbstractSerializer class >> new [
	self error: 'dont use me'
]

{ #category : #accessing }
AbstractSerializer class >> priority [
	^ -1 "Negetive means: forget me!"
]

{ #category : #'as yet unclassified' }
AbstractSerializer class >> serializer: anObject [
	|instance|
	instance := super new.
	instance object: anObject.
	^ instance
]

{ #category : #'as yet unclassified' }
AbstractSerializer class >> supportingTypes [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
AbstractSerializer class >> unserialize: dictionary [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
AbstractSerializer class >> unserializer: aDic [
		| instance |
	instance := super new.
	instance dictionary: aDic.
	^ instance
]

{ #category : #'as yet unclassified' }
AbstractSerializer >> captureResult: aSelector [
	^ true
]

{ #category : #accessing }
AbstractSerializer >> dictionary: aDic [
	dictionary := aDic
]

{ #category : #private }
AbstractSerializer >> findLastInMemory: aMemory [
	| idx |
	idx := aMemory indexOf: dictionary.
	^ (aMemory first: idx) reverse
		detect: [ :a | 
			(a at: #name) = (dictionary  at: #name)
				and: [ (a at: #id) < (dictionary at: #id) ] ]
		ifNone: [ ^ nil ]
]

{ #category : #testing }
AbstractSerializer >> isEqualWith: theLast [
	self subclassResponsibility
]

{ #category : #asserting }
AbstractSerializer >> makeAssertsBasedOnLast: theLast [
	^ self class
		makeAssertName: (dictionary at: #name)
		value: dictionary
		last: theLast
]

{ #category : #private }
AbstractSerializer >> makeAssertsBasedOnMemory: aMemory [
	| theLast |
	^ self makeAssertsBasedOnLast: nil
	"theLast := self findLastInMemory: aMemory."
	"(theLast isNil or: [ (self isEqualWith: theLast) not ])
		ifTrue: [ ^ self makeAssertsBasedOnLast: theLast ]
		ifFalse: [ ^ {} ]"
]

{ #category : #private }
AbstractSerializer >> makeAssertsBasedOnMemory: aMemory differnetial: aBoolean [
	| theLast |
	theLast := nil.
	aBoolean ifTrue: [theLast := self findLastInMemory: aMemory].
	^ self makeAssertsBasedOnLast: theLast
	"(theLast isNil or: [ (self isEqualWith: theLast) not ])
		ifTrue: [ ^ self makeAssertsBasedOnLast: theLast ]
		ifFalse: [ ^ {} ]"
]

{ #category : #accessing }
AbstractSerializer >> maxDepth [
	^ 3
]

{ #category : #accessing }
AbstractSerializer >> object: anObject [
	object := anObject 
]

{ #category : #private }
AbstractSerializer >> serialize [
	^ self serializeDepth: self maxDepth
]

{ #category : #private }
AbstractSerializer >> serializeDepth: anInt [
	self subclassResponsibility
]

{ #category : #private }
AbstractSerializer >> serializeSpecialDepth: anInt type: aString extra: anObject [
	^ self serializeDepth: anInt
]

{ #category : #'as yet unclassified' }
AbstractSerializer >> unserialize [
	^ self class unserialize: dictionary
]
