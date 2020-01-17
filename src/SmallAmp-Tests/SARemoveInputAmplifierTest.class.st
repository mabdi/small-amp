"
A SARemoveInputAmplifierTest is a test class for testing the behavior of SARemoveInputAmplifier
"
Class {
	#name : #SARemoveInputAmplifierTest,
	#superclass : #TestCase,
	#instVars : [
		'amplifier',
		'item1Line',
		'item2Line'
	],
	#category : #'SmallAmp-Tests-Core'
}

{ #category : #running }
SARemoveInputAmplifierTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	amplifier := SARemoveInputAmplifier initializeWith: SAConfig new.
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
SARemoveInputAmplifierTest >> testDontRemove [
	| res |
	res := item1Line inputAmplifyBy: amplifier.
	self assertEmpty: res
]

{ #category : #tests }
SARemoveInputAmplifierTest >> testRemove [
	| res |
	res := item2Line inputAmplifyBy: amplifier.
	self
		assertMethodSourceCode: (res at: 1) asString
		equals:
			'testDeposit_R0
	| b |
	b deposit: 10.
	b deposit: 100'
]
