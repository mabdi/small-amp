"
A SANullifyInputAmplifierTest is a test class for testing the behavior of SANullifyInputAmplifier
"
Class {
	#name : #SANullifyInputAmplifierTest,
	#superclass : #TestCase,
	#instVars : [
		'amplifier',
		'item1Line',
		'item2Line'
	],
	#category : #'SmallAmp-Tests-Core'
}

{ #category : #running }
SANullifyInputAmplifierTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	amplifier := SANullifyInputAmplifier initializeWith: SAConfig new.
	item1Line := SATestMethod
		with: (SmallBankTest >> #testInit) sourceCode
		class: SmallBankTest
		targets: SmallBank.
	item2Line := SATestMethod
		with: (SmallBankTest >> #testDeposit) sourceCode
		class: SmallBankTest
		targets: SmallBank.
	item1Line strip.
	item2Line strip.
		
]

{ #category : #tests }
SANullifyInputAmplifierTest >> testNullify [
	| res |
	res := item2Line inputAmplifyBy: amplifier.
	self
		assertMethodSourceCode: (res at: 1) asString
		equals:
			'testDeposit_N0
	| b |
	b := SmallBank new.
	b deposit: nil.
	b deposit: 100'.
	self
		assertMethodSourceCode: (res at: 2) asString
		equals:
			'testDeposit_N1
	| b |
	b := SmallBank new.
	b deposit: 10.
	b deposit: nil'.
]
