"
A SARotateLiteralsInputAmplifierTest is a test class for testing the behavior of SARotateLiteralsInputAmplifier
"
Class {
	#name : #SARotateLiteralsInputAmplifierTest,
	#superclass : #TestCase,
	#instVars : [
		'item1Line',
		'item2Line',
		'amplifier'
	],
	#category : #'SmallAmp-Tests-Core'
}

{ #category : #running }
SARotateLiteralsInputAmplifierTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	amplifier := SARotateLiteralsInputAmplifier
		initializeWith: SAConfig new.
	item1Line := SATestMethod
		with: (SmallBankTest >> #testInit) sourceCode
		class: SmallBankTest
		targets: SmallBank.
	item2Line := SATestMethod
		with: (SmallBankTest >> #testDeposit) sourceCode
		class: SmallBankTest
		targets: SmallBank.
	item1Line strip.
	item2Line strip
]

{ #category : #tests }
SARotateLiteralsInputAmplifierTest >> testItem1 [
	| res |
	res := item2Line inputAmplifyBy: amplifier.
	self
		assertMethodSourceCode: (res at: 1) asString
		equals:
			'testDeposit_O0
	| b |
	b := SmallBank new.
	b deposit: 100.
	b deposit: 10'
]
