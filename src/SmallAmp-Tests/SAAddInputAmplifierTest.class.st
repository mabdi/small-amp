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
		'amplifierProfile',
		'toRemove'
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
	item2Line strip.
	toRemove := OrderedCollection new.
]

{ #category : #running }
SAAddInputAmplifierTest >> tearDown [ 
	toRemove do: #removeFromSystem
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

{ #category : #tests }
SAAddInputAmplifierTest >> testInstanceVaribale [
	| res item cls codes |
	cls := SAASTHelper new
		makeClassFrom:
			{'setUp f := FakeSmallBank new' . 'testO1 self assert: f balance equals: 0'}
		instanceVars: 'f'.
	item := SATestMethod
		with: (cls >> #testO1) sourceCode
		class: cls
		targets: {FakeSmallBank}.
	res := item inputAmplifyBy: amplifierProfile.
	self assert: res size equals: 5.
	codes := res
		collect: [ :r | 
			r testMethod
				copyWithRegex: 'testO1_A(\d+)'
				matchesReplacedWith: 'testO1_A' ].
	codes sort.
	self
		assertMethodSourceCode: codes first asString
		equals:
			'testO1_A
	f balance.
	self assert: f balance equals: 0'
]
