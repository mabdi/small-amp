Class {
	#name : #AbstractSerializer,
	#superclass : #Object,
	#instVars : [
		'object',
		'dictionary'
	],
	#category : #'Amplification-Helpers'
}

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
	^ 5
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
