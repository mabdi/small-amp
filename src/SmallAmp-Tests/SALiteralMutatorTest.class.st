"
A SALiteralMutatorTest is a test class for testing the behavior of SALiteralMutator
"
Class {
	#name : #SALiteralMutatorTest,
	#superclass : #TestCase,
	#instVars : [
		'mutator'
	],
	#category : #'SmallAmp-Tests-Helpers'
}

{ #category : #running }
SALiteralMutatorTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	mutator := SALiteralMutator new
]

{ #category : #test }
SALiteralMutatorTest >> testMutateArrayNode [
	| t1 t2 |
	t1 := mutator mutateArrayNode: (RBParser parseExpression: '{}').
	self assert: t1 size equals: 1.
	self assert: t1 first formattedCode equals: '{nil}'.
	t2 := mutator
		mutateArrayNode: (RBParser parseExpression: '{1. 2. ''three''}').
	self assert: t2 size equals: 4.
	self assert: t2 first formattedCode equals: '{}'.
	self assertSourceCode: t2 second formattedCode equals: '{1. 1. 1}'.
	self assertSourceCode: t2 third formattedCode equals: '{nil. nil. nil}'.
	self assertSourceCode: t2 fourth  formattedCode equals: '{1 . 2 . ''three'' . nil}'
]

{ #category : #test }
SALiteralMutatorTest >> testMutateCharacter [
	mutator mutateCharacter: Character null
]

{ #category : #test }
SALiteralMutatorTest >> testMutateEmptyString [
	self
		deny:
			((mutator mutateString: '') anySatisfy: [ :node | node value isEmpty ]).
	self assertEmpty: (mutator removeRandom: '').
	self assertEmpty: (mutator updateRandom: '').
	self assert: (mutator insertRandom: '') size equals: 1.
]

{ #category : #test }
SALiteralMutatorTest >> testMutateLiteralArrayNode [
	| t1 t2 |
	t1 := mutator
		mutateLiteralArrayNode: (RBParser parseExpression: '#()').
	self assert: t1 size equals: 1.
	self assert: t1 first formattedCode equals: '#(nil)'.
	t1 := mutator
		mutateLiteralArrayNode: (RBParser parseExpression: '#[]').
	self assert: t1 size equals: 1.
	self assert: t1 first formattedCode equals: '#[0]'.
	t2 := mutator
		mutateLiteralArrayNode: (RBParser parseExpression: '#(foo bar hi)').
	self assert: t2 size equals: 4.
	self assert: t2 first formattedCode equals: '#()'.
	self assertSourceCode: t2 second formattedCode equals: '#(foo foo foo)'.
	self
		assertSourceCode: t2 third formattedCode
		equals: '#(nil nil nil)'.
	self
		assertSourceCode: t2 fourth formattedCode
		equals: '#(foo bar hi nil)'.
	t2 := mutator
		mutateLiteralArrayNode: (RBParser parseExpression: '#[1 2 3 4]').
	self assert: t2 size equals: 4.
	self assert: t2 first formattedCode equals: '#[]'.
	self assertSourceCode: t2 second formattedCode equals: '#[1  1  1 1]'.
	self
		assertSourceCode: t2 third formattedCode
		equals: '#[0 0 0 0]'.
	self
		assertSourceCode: t2 fourth formattedCode
		equals: '#[1 2 3  4 0]'
]
