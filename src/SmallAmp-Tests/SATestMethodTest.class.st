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
