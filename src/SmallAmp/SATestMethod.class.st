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
	#category : #'SmallAmp-Model'
}

{ #category : #'as yet unclassified' }
SATestMethod class >> with: aTestMethod class: aTestClass targets: objectsUnderTest [
	^ self new
		  initializeWith: aTestMethod
		  class: aTestClass
		  targets: objectsUnderTest
]

{ #category : #cleanup }
SATestMethod >> assertionAmplifyBy: anAmplifier [
	testMethod := anAmplifier amplifyAssertionsFor: self
]

{ #category : #removing }
SATestMethod >> astHelper [
	^ SAASTHelper new
]

{ #category : #cleanup }
SATestMethod >> cleanUp [
	testMethod := (self astHelper cleanUp: testMethod)
]

{ #category : #'as yet unclassified' }
SATestMethod >> cleanedUpCopy [
	| obj |
	obj := self clone.
	obj cleanUp.
	^ obj
]

{ #category : #copying }
SATestMethod >> clone [
	| obj |
	obj := self class
		       with: self testMethod 
		       class: self testClass
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
	selectorOriginal := self astHelper extractMethodName:
		                                   aTestMethod
]

{ #category : #cleanup }
SATestMethod >> inputAmplifyBy: anAmplifier [
	| idx versions |
	versions := anAmplifier amplifyInputsFor: self.
	idx := 0.
	^ versions collect: [ :mtd | 
		  | cp |
		  cp := self renamedCopy: '_' , idx asString.
		  cp testMethod:
			  (self astHelper renameMethodName: mtd append: '_' , idx asString)
				  formattedCode.
		  idx := idx + 1.
		  cp ]
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
		       with: self testMethod
		       class: self testClass
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
	testMethod := (self astHelper
		                      renameMethodName: testMethod
		                      append: '_amp') formattedCode 
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
