"
A SAUniqLiteralsInputAmplifierTest is a test class for testing the behavior of SAUniqLiteralsInputAmplifier
"
Class {
	#name : #SAUniqLiteralsInputAmplifierTest,
	#superclass : #TestCase,
	#instVars : [
		'amplifier',
		'item1Line',
		'item2Line'
	],
	#category : #'SmallAmp-Tests-Core'
}

{ #category : #running }
SAUniqLiteralsInputAmplifierTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	amplifier := SAUniqLiteralsInputAmplifier initializeWith: SAConfig new.
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
SAUniqLiteralsInputAmplifierTest >> testItem1 [
	| res codes |
	res := item2Line inputAmplifyBy: amplifier.
	codes := res
		collect: [ :r | 
			r testMethod
				copyWithRegex: 'testDeposit_U(\d+)'
				matchesReplacedWith: 'testDeposit_A' ].
	codes := codes sort.
	self
		assertMethodSourceCode: (res at: 1) asString
		equals:
			'testDeposit_U0
	| b |
	b := SmallBank new.
	b deposit: 100.
	b deposit: 100'
]
