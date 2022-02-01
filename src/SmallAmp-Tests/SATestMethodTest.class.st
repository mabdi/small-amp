"
A SATestMethodTest is a test class for testing the behavior of SATestMethod
"
Class {
	#name : #SATestMethodTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Model'
}

{ #category : #tests }
SATestMethodTest >> testInitFrom [
	self
		should: [ SATestMethod from: SmallBank >> #deposit: ]
		raise: Error.
	SATestMethod from: SmallBankTest >> #testDeposit "No Error"
]

{ #category : #tests }
SATestMethodTest >> testScoreWith [

	| weights model |
	weights := { 
		           (FakeSmallBank >> #deposit: -> 4).
		           (FakeSmallBank >> #balance -> 1).
		           (FakeSmallBank >> #initialize -> 5) } asDictionary.
	model := SATestMethod from: FakeSmallBankTest >> #testDeposit.
	model scoreWith: weights.
	self assert: model score equals: 36
]

{ #category : #tests }
SATestMethodTest >> testScoreWith_empty [

	| weights model |
	weights := {  } asDictionary.
	model := SATestMethod from: FakeSmallBankTest >> #testDeposit.
	model scoreWith: weights.
	self assert: model score equals: 0
]

{ #category : #tests }
SATestMethodTest >> testScoreWith_zero [

	| weights model |
	weights := { 
		           (FakeSmallBank >> #deposit: -> 0).
		           (FakeSmallBank >> #balance -> 0).
		           (FakeSmallBank >> #initialize -> 0) } asDictionary.
	model := SATestMethod from: FakeSmallBankTest >> #testDeposit.
	model scoreWith: weights.
	self assert: model score equals: 0
]

{ #category : #tests }
SATestMethodTest >> testScoreWith_zeroCoverage [

	| weights model |
	weights := { 
		           (FakeSmallBank >> #withdraw: -> 100).
		           (FakeSmallBank >> #deposit: -> 0).
		           (FakeSmallBank >> #balance -> 0).
		           (FakeSmallBank >> #initialize -> 0) } asDictionary.
	model := SATestMethod from: FakeSmallBankTest >> #testDeposit.
	model scoreWith: weights.
	self assert: model score equals: 1
]

{ #category : #tests }
SATestMethodTest >> testStripRemoveKey2 [

	| testMethod testMethodSrc |
	testMethodSrc := 'testRemoveKey2
	"https://github.com/SeasideSt/Grease/issues/81"
	collection
		at: ''x'' put: 1;
		at: ''y'' put: 2;
		at: ''z'' put: 3.

	self
		assert: (collection removeKey: ''z'') equals: (self allowsDuplicateKeys ifTrue: [ #(3) ] ifFalse: [ 3 ]);
		assert: collection size equals: 2.

	collection := self newCollection
		at: ''x'' put: 1;
		at: ''y'' put: 2;
		at: ''z'' put: 3;
		yourself.	
			
	self
		assert: (collection removeKey: ''y'') equals: (self allowsDuplicateKeys ifTrue: [ #(2) ] ifFalse: [ 2 ]);
		assert: collection size equals: 2'.

	testMethod := SATestMethod
		              with: testMethodSrc
		              class: FakeSmallBankTest
		              targets: FakeSmallBankTest smallAmpTargetClasses.

	testMethod strip.
	self flag: #todo. "strip in this case doesn't clean the cascaded assertions"
	testMethod normalize.
	testMethod strip.
	self
		assertMethodSourceCode:
		(SAGenericMethods new renameTempVars: testMethod testMethod)
		equals: (SAGenericMethods new renameTempVars: 'testRemoveKey2

	"https://github.com/SeasideSt/Grease/issues/81"

	| tmp_IAd6qpeOjp1 tmp_YW6vN6dny02 tmp_vnOV9KLNrq3 tmp_d2IpCXd7Gu4 tmp_VeTfO3RnGE5 tmp_QXB0JXnQ076 tmp_0KYPlk6q6E7 tmp_N5fK9YvFsh8 tmp_tT7fSthwmR9 tmp_5YUPQ9oJuJ10 |
	tmp_IAd6qpeOjp1 := collection at: ''x'' put: 1.
	tmp_YW6vN6dny02 := collection at: ''y'' put: 2.

	collection := collection at: ''z'' put: 3.
	tmp_VeTfO3RnGE5 := self newCollection.
	tmp_QXB0JXnQ076 := tmp_VeTfO3RnGE5 at: ''x'' put: 1.
	tmp_0KYPlk6q6E7 := tmp_VeTfO3RnGE5 at: ''y'' put: 2.
	tmp_N5fK9YvFsh8 := tmp_VeTfO3RnGE5 at: ''z'' put: 3.

	collection := tmp_VeTfO3RnGE5 yourself')
]
