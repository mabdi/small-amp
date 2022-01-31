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
