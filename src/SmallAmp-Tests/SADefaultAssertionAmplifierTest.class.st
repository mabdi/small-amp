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

	aConfig := SAConfig new testRunTimeOut: 10000; flackyTestRepeat:3.
	ins := SADefaultAssertionAmplifier initializeWith: aConfig
]

{ #category : #tests }
SADefaultAssertionAmplifierTest >> testCase1 [
	| src sourceCodeWithAssertions |
	src := 'foo 10 to: 100 by: 0'.
	sourceCodeWithAssertions := ins
		amplifyAssertionsFor: (self testModelFor: src).
		self assert: sourceCodeWithAssertions isNil 
]

{ #category : #tests }
SADefaultAssertionAmplifierTest >> testModelFor: src [
	^ SATestMethod with: src class: SmallBankTest targets: {SmallBank}
]
