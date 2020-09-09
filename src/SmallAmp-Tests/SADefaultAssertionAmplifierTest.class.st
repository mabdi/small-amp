"
A SADefaultAssertionAmplifierTest is a test class for testing the behavior of SADefaultAssertionAmplifier
"
Class {
	#name : #SADefaultAssertionAmplifierTest,
	#superclass : #TestCase,
	#instVars : [
		'aConfig',
		'ins'
	],
	#category : #'SmallAmp-Tests-Core'
}

{ #category : #running }
SADefaultAssertionAmplifierTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	aConfig := SAConfig default.
	ins := SADefaultAssertionAmplifier initializeWith: aConfig.
	ins testRunTimeoutMillis: 1000
]

{ #category : #tests }
SADefaultAssertionAmplifierTest >> testCase1 [
	"step 0 in to:by:"
	| src sourceCodeWithAssertions |
	src := 'foo 10 to: 100 by: 0'.
	sourceCodeWithAssertions := ins
		amplifyAssertionsFor: (self testModelFor: src).
	self assert: sourceCodeWithAssertions isNil
]

{ #category : #tests }
SADefaultAssertionAmplifierTest >> testCase2 [
	| src sourceCodeWithAssertions testModel |
	src := 'testFoo | x y | x:= SATestObject new. x showError. y:= x field1 * 2'.
	testModel := SATestMethod
		with: src
		class: SmallBankTest
		targets: {SATestObject}.
	sourceCodeWithAssertions := ins amplifyAssertionsFor: testModel.
	self
		deny: (sourceCodeWithAssertions includesSubstring: 'y:= x field1 * 2')
]

{ #category : #tests }
SADefaultAssertionAmplifierTest >> testModelFor: src [
	^ SATestMethod with: src class: SmallBankTest targets: {SmallBank}
]
