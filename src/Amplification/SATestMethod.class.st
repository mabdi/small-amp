Class {
	#name : #SATestMethod,
	#superclass : #Object,
	#instVars : [
		'testMethod',
		'testClass',
		'testTargets',
		'selector',
		'selectorOriginal'
	],
	#category : #'Amplification-Model'
}

{ #category : #'as yet unclassified' }
SATestMethod class >> with: aTestMethod class: aTestClass targets: objectsUnderTest [
	^ self new
		  initializeWith: aTestMethod
		  class: aTestClass
		  targets: objectsUnderTest
]

{ #category : #cleanup }
SATestMethod >> assertAmplifyBy: anAmplifier [ 
	testMethod := anAmplifier assertionAmplify: self
]

{ #category : #removing }
SATestMethod >> astHelper [
	^ ASTHelper new
]

{ #category : #cleanup }
SATestMethod >> cleanUp [
	testMethod := (self astHelper cleanUp: testMethod)
]

{ #category : #copying }
SATestMethod >> clone [
	| obj |
	obj := self class
		       with: self testClass
		       class: self testMethod
		       targets: self testTargets.
	obj testMethod: self testMethod.
	^ obj
]

{ #category : #accessing }
SATestMethod >> initializeWith: aTestMethod class: aTestClass targets: objectsUnderTest [
	self initialize.
	testMethod := aTestMethod.
	testClass := aTestClass.
	testTargets := objectsUnderTest.
	testTargets := selectorOriginal := self astHelper extractMethodName:
		                                   aTestMethod
]

{ #category : #printing }
SATestMethod >> printOn: aStream [
	"Append to the argument, aStream, a sequence of characters that  
	identifies the receiver."

	aStream nextPutAll: testMethod
]

{ #category : #removing }
SATestMethod >> renamedCopy: postfix [
	| obj |
	obj := self class
		       with: self testClass
		       class: self testMethod
		       targets: self testTargets.
	obj selectorAppend: postfix.
	^ obj
]

{ #category : #accessing }
SATestMethod >> selector [
	^ selector ifNil: [ 
		  self flag: #TODO. "keep testMethod as AST instead of string"
		  selector := self astHelper extractMethodName: testMethod ]
]

{ #category : #'as yet unclassified' }
SATestMethod >> selectorAppend: postfix [
	testMethod := self astHelper
		                      renameMethodName: testMethod
		                      append: '_amp'
]

{ #category : #accessing }
SATestMethod >> selectorOriginal [
	^ selectorOriginal
]

{ #category : #removing }
SATestMethod >> strip [
	testMethod := self astHelper removeAssertions: testMethod
]

{ #category : #accessing }
SATestMethod >> testClass [ 
	^ testClass 
]

{ #category : #accessing }
SATestMethod >> testMethod [
	^ testMethod
]

{ #category : #accessing }
SATestMethod >> testMethod: atestMethodModified [
	testMethod := atestMethodModified
]

{ #category : #accessing }
SATestMethod >> testTargets [
	^ testTargets
]
