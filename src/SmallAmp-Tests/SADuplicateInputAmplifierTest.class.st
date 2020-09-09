"
A SADuplicateInputAmplifierTest is a test class for testing the behavior of SADuplicateInputAmplifier
"
Class {
	#name : #SADuplicateInputAmplifierTest,
	#superclass : #TestCase,
	#instVars : [
		'amplifier',
		'item1Line',
		'item2Line'
	],
	#category : #'SmallAmp-Tests-Core'
}

{ #category : #running }
SADuplicateInputAmplifierTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	amplifier := SADuplicateInputAmplifier initializeWith: SAConfig new.
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
SADuplicateInputAmplifierTest >> testDuplicate [
	| res |
	res := item2Line inputAmplifyBy: amplifier.
	self
		assertMethodSourceCode: (res at: 1) asString
		equals:
			'testDeposit_D0
	| b |
	b := SmallBank new.
	SmallBank new.
	b deposit: 10.
	b deposit: 100'
]
