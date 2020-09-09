"
A SAAddInputAmplifierTest is a test class for testing the behavior of SAAddInputAmplifier
"
Class {
	#name : #SAAddInputAmplifierTest,
	#superclass : #TestCase,
	#instVars : [
		'item1Line',
		'item2Line',
		'config',
		'amplifierNoProfile',
		'amplifierProfile'
	],
	#category : #'SmallAmp-Tests-Core'
}

{ #category : #running }
SAAddInputAmplifierTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	| test target |
	test := FakeSmallBankTest.
	target := {FakeSmallBank}.
	config := SAConfig default.
	config profiler profileClasses: target byRunning: test.
	amplifierNoProfile := SAAddInputAmplifier
		initializeWith: SAConfig default.
	amplifierProfile := SAAddInputAmplifier initializeWith: config.
	item1Line := SATestMethod
		with: (test >> #testInit) sourceCode
		class: test
		targets: target.
	item2Line := SATestMethod
		with: (test >> #testDeposit) sourceCode
		class: test
		targets: target.
	item1Line strip.
	item2Line strip
]

{ #category : #tests }
SAAddInputAmplifierTest >> testAdd1 [
	| res codes |
	res := item2Line inputAmplifyBy: amplifierNoProfile.
	self assert: res size equals: 6.
	codes := res
		collect: [ :r | 
			r testMethod
				copyWithRegex: 'testDeposit_A(\d+)'
				matchesReplacedWith: 'testDeposit_A' ].
	codes sort.
	self
		assertMethodSourceCode: (codes at: 5) asString
		equals:
			'testDeposit_A
	| b |
	b := FakeSmallBank new.
	b deposit: 10.
	b rand.
	b deposit: 100'.
	self
		assertMethodSourceCode: (codes at: 1) asString
		equals:
			'testDeposit_A
	| b |
	b := FakeSmallBank new.
	b balance.
	b deposit: 10.
	b deposit: 100'
]

{ #category : #tests }
SAAddInputAmplifierTest >> testAdd2 [
	| res codes |
	res := item2Line inputAmplifyBy: amplifierProfile.
	self assert: res size equals: 15.
	codes := res
		collect: [ :r | 
			r testMethod
				copyWithRegex: 'testDeposit_A(\d+)'
				matchesReplacedWith: 'testDeposit_A' ].
	codes sort.
	self
		assertMethodSourceCode: (codes at: 2) asString
		equals:
			'testDeposit_A
	| b |
	b := FakeSmallBank new.
	b deposit: 10.
	b balance.
	b deposit: 100'.
	self
		assertMethodSourceCode: (codes at: 14) asString
		equals:
			'testDeposit_A
	| b |
	b := FakeSmallBank new.
	b rand.
	b deposit: 10.
	b deposit: 100'
]
