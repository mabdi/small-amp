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
SALiteralMutatorTest >> testMutateCharacter [
	self shouldnt: [ mutator mutateCharacter: Character null ] raise: PrimitiveFailed
	
]
