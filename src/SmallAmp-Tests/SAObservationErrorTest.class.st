"
A SAObservationErrorTest is a test class for testing the behavior of SAObservationError
"
Class {
	#name : #SAObservationErrorTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Model'
}

{ #category : #tests }
SAObservationErrorTest >> testBuildAssertionForError [
	| item |
	item := SAObservationError forError: OutOfMemory.
	self assert: item buildAssertionForError formattedCode equals: 'self should: fake raise: OutOfMemory description: ''smallAmp'''
]

{ #category : #tests }
SAObservationErrorTest >> testBuildAssertions [
	| item |
	item := SAObservationError forError: OutOfMemory.
	self assert: item buildAssertions class equals: OrderedCollection.
	self deny: item buildAssertions isEmpty 
]

{ #category : #tests }
SAObservationErrorTest >> testInit [
	| item |
	item := SAObservationError forError: OutOfMemory.
	self assert: item theError equals: OutOfMemory.
]
