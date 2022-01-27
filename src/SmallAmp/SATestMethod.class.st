Class {
	#name : #SATestMethod,
	#superclass : #Object,
	#instVars : [
		'testMethod',
		'testClass',
		'testTargets',
		'selector',
		'selectorOriginal',
		'observedState',
		'score',
		'immediateCovered',
		'totalCovered',
		'isAmplified'
	],
	#category : #'SmallAmp-Model'
}

{ #category : #'instance creation' }
SATestMethod class >> from: aCompiledMethod [
	aCompiledMethod methodClass isTestCase
		ifFalse: [ self error: 'only test methods are accepted.' ].
	^ self new
		initializeWith: aCompiledMethod sourceCode
		class: aCompiledMethod methodClass
		targets: aCompiledMethod methodClass smallAmpTargetClasses
]

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
	^ SAGenericMethods new
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
	obj selectorOriginal: self selectorOriginal.
	^ obj
]

{ #category : #initialization }
SATestMethod >> initialize [ 
	self isAmplified: false
]

{ #category : #accessing }
SATestMethod >> initializeWith: aTestMethod class: aTestClass targets: objectsUnderTest [

	self initialize.
	testMethod := aTestMethod.
	testClass := aTestClass.
	testTargets := objectsUnderTest.
	selectorOriginal := self astHelper extractMethodName: aTestMethod
]

{ #category : #cleanup }
SATestMethod >> inputAmplifyBy: anAmplifier [
	| idx versions |
	versions := anAmplifier amplifyInputsFor: self.
	idx := 0.
	^ versions
		collect: [ :mtd | 
			| cp |
			cp := self
				renamedCopy: '_' , anAmplifier namingPrefix , idx asString.
			cp
				testMethod:
					(self astHelper
						renameMethodName: mtd
						append: '_' , anAmplifier namingPrefix , idx asString)
						formattedCode.
			idx := idx + 1.
			cp ]
]

{ #category : #accessing }
SATestMethod >> isAmplified [

	^ isAmplified
]

{ #category : #accessing }
SATestMethod >> isAmplified: anObject [

	isAmplified := anObject
]

{ #category : #removing }
SATestMethod >> normalize [
	| ast |
	ast := self astHelper parsedMethodFrom: testMethod.
	SAMethodNormalizingRewriter runWith: ast.
	testMethod := ast formattedCode
]

{ #category : #accessing }
SATestMethod >> observedState [
	^ observedState
]

{ #category : #accessing }
SATestMethod >> observedState: anObject [
	observedState := anObject
]

{ #category : #printing }
SATestMethod >> printOn: aStream [
	"Append to the argument, aStream, a sequence of characters that  
	identifies the receiver."

	aStream nextPutAll: testMethod
]

{ #category : #removing }
SATestMethod >> removeAssertionsAndExtract [
	| m |
	m := SAAssertTransform
		transformAllAsserts: (self astHelper parsedMethodFrom: testMethod).
	testMethod := m formattedCode
]

{ #category : #removing }
SATestMethod >> renamedCopy: postfix [

	| obj |
	obj := self class
		       with: self testMethod
		       class: self testClass
		       targets: self testTargets.
	obj selectorAppend: postfix.
	obj selectorOriginal: self selectorOriginal.
	^ obj
]

{ #category : #accessing }
SATestMethod >> score [

	^ score
]

{ #category : #accessing }
SATestMethod >> score: aValue [
	score:= aValue
]

{ #category : #'as yet unclassified' }
SATestMethod >> scoreWith: methodsScore [

	| sumImmediateCovered sumTotalCovered |
	immediateCovered ifNil: [ 
		immediateCovered := SACoverageCountingHelper new
			                    selector: self selector;
			                    testMethod: self testMethod;
			                    testClass: self testClass;
			                    coverageOn: methodsScore keys;
			                    findImmediateCoveredMethods ].
	totalCovered ifNil: [ 
		totalCovered := SACoverageCountingHelper new
			                selector: self selector;
			                testMethod: self testMethod;
			                testClass: self testClass;
			                coverageOn: methodsScore keys;
			                findAllCoveredMethods ].
	sumImmediateCovered := immediateCovered
		                        ifEmpty: [ 0 ]
		                        ifNotEmpty: [ 
		                       (immediateCovered collect: [ :x | 
			                        methodsScore at: x ifAbsent: [ 0 ] ]) sum ].
	sumTotalCovered := totalCovered
		                   ifEmpty:   [ 0 ]
		                    ifNotEmpty: [ 
		                   (totalCovered collect: [ :x | methodsScore at: x ifAbsent: [ 0 ] ])
			                   sum ].

	self flag: #todo. "make me configurable"
	score := sumImmediateCovered * 2 + sumTotalCovered
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

{ #category : #accessing }
SATestMethod >> selectorOriginal: anObject [

	selectorOriginal := anObject
]

{ #category : #accessing }
SATestMethod >> signAsSmallAmp [

	testMethod := self astHelper
		              signAsSmallAmp: testMethod
		              original:
		              (testClass smallAmpOriginalTestCase lookupSelector: selectorOriginal).
	testMethod := self astHelper signAsSmallAmp: testMethod
]

{ #category : #removing }
SATestMethod >> strip [
	testMethod := self astHelper strip: testMethod.
	
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
