Class {
	#name : #SATestMethod,
	#superclass : #Object,
	#instVars : [
		'testMethod',
		'testClass',
		'testMethodModified',
		'testTargets',
		'selector',
		'selectorOriginal'
	],
	#category : #'Amplification-Model'
}

{ #category : #'as yet unclassified' }
SATestMethod class >> withClass: aClass method: aMethod targets: colTarget [
	^ self new
		testClass: aClass;
		testMethod: aMethod;
		testTargets: colTarget;
		yourself
]

{ #category : #copying }
SATestMethod >> clone [
	| obj |
	obj := self class
		withClass: self testClass
		method: self testMethod
		targets: self testTargets.
	obj testMethodModified: self testMethodModified.
	^ obj
]

{ #category : #printing }
SATestMethod >> printOn: aStream [
	"Append to the argument, aStream, a sequence of characters that  
	identifies the receiver."

	aStream nextPutAll: testMethodModified
]

{ #category : #accessing }
SATestMethod >> selector [
	^ selector
		ifNil: [ selector := ASTHelper new
				extractMethodName: testMethodModified ]
]

{ #category : #accessing }
SATestMethod >> selectorOriginal [
	^ selectorOriginal
		ifNil: [ selectorOriginal := ASTHelper new
				extractMethodName: testMethod ]
]

{ #category : #accessing }
SATestMethod >> testClass [ 
	^ testClass 
]

{ #category : #accessing }
SATestMethod >> testClass: atestClass [
	testClass := atestClass 
]

{ #category : #accessing }
SATestMethod >> testMethod [
	^ testMethod
]

{ #category : #accessing }
SATestMethod >> testMethod: atestMethod [
	testMethod := atestMethod
]

{ #category : #accessing }
SATestMethod >> testMethodModified [
	^ testMethodModified ifNil: [ ^ testMethod  ]
]

{ #category : #accessing }
SATestMethod >> testMethodModified: atestMethodModified [
	testMethodModified:= atestMethodModified
]

{ #category : #accessing }
SATestMethod >> testTargets [
	^ testTargets
]

{ #category : #accessing }
SATestMethod >> testTargets: colTarget [
	"comment stating purpose of message"

	testTargets := colTarget 
]
