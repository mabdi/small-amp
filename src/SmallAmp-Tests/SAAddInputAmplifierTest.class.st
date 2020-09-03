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
	| res |
	res := item2Line inputAmplifyBy: amplifierNoProfile.
	self assert: res size equals: 9.
	self
		assertMethodSourceCode: (res at: 1) asString
		equals:
			'testDeposit_A0
	| b |
	b := FakeSmallBank new.
	b initialize.
	b deposit: 10.
	b deposit: 100'.
	self
		assertMethodSourceCode: (res at: 9) asString
		equals:
			'testDeposit_A8
	| b |
	b := FakeSmallBank new.
	b deposit: 10.
	b deposit: 100.
	b balance'
]

{ #category : #tests }
SAAddInputAmplifierTest >> testAdd2 [
	| res |
	res := item2Line inputAmplifyBy: amplifierProfile.
	self assert: res size equals: 18.
	self
		assertMethodSourceCode: (res at: 3) asString
		equals:
			'testDeposit_A2
	| b |
	b := FakeSmallBank new.
	b loadFrom: FakeSmallBank new.
	b deposit: 10.
	b deposit: 100'.
	self
		assertMethodSourceCode: (res at: 4) asString
		equals: 'testDeposit_A3
	| b |
	b := FakeSmallBank new.
	b withdraw: 30.
	b deposit: 10.
	b deposit: 100'
]
