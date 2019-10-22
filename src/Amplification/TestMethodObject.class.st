Class {
	#name : #TestMethodObject,
	#superclass : #Object,
	#instVars : [
		'testMethod',
		'testClass',
		'testMethodModified',
		'testTargets',
		'selector',
		'selectorOriginal'
	],
	#category : #'Amplification-Core'
}

{ #category : #'as yet unclassified' }
TestMethodObject class >> withClass: aClass method: aMethod targets: colTarget [
	^ self new
		testClass: aClass;
		testMethod: aMethod;
		testTargets: colTarget;
		yourself
]

{ #category : #copying }
TestMethodObject >> clone [
	| obj |
	obj := self class
		withClass: self testClass
		method: self testMethod
		targets: self testTargets.
	obj testMethodModified: self testMethodModified.
	^ obj
]

{ #category : #printing }
TestMethodObject >> printOn: aStream [
	"Append to the argument, aStream, a sequence of characters that  
	identifies the receiver."

	aStream nextPutAll: testMethodModified
]

{ #category : #accessing }
TestMethodObject >> selector [
	^ selector
		ifNil: [ selector := ASTHelper uniqueInstance
				extractMethodName: testMethodModified ]
]

{ #category : #accessing }
TestMethodObject >> selectorOriginal [
	^ selectorOriginal
		ifNil: [ selectorOriginal := ASTHelper uniqueInstance
				extractMethodName: testMethod ]
]

{ #category : #accessing }
TestMethodObject >> testClass [ 
	^ testClass 
]

{ #category : #accessing }
TestMethodObject >> testClass: atestClass [
	testClass := atestClass 
]

{ #category : #accessing }
TestMethodObject >> testMethod [
	^ testMethod
]

{ #category : #accessing }
TestMethodObject >> testMethod: atestMethod [
	testMethod := atestMethod
]

{ #category : #accessing }
TestMethodObject >> testMethodModified [
	^ testMethodModified ifNil: [ ^ testMethod  ]
]

{ #category : #accessing }
TestMethodObject >> testMethodModified: atestMethodModified [
	testMethodModified:= atestMethodModified
]

{ #category : #accessing }
TestMethodObject >> testTargets [
	^ testTargets
]

{ #category : #accessing }
TestMethodObject >> testTargets: colTarget [
	"comment stating purpose of message"

	testTargets := colTarget 
]
