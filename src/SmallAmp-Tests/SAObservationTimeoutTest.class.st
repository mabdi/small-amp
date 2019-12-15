"
A SAObservationTimeoutTest is a test class for testing the behavior of SAObservationTimeout
"
Class {
	#name : #SAObservationTimeoutTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Model'
}

{ #category : #tests }
SAObservationTimeoutTest >> testBuildAssertionForTimeout [
	| item |
	item := SAObservationTimeout forTimeout: 125.
	self
		assert: item buildAssertionForTimeout formattedCode
		equals:
		'self
	should: fake
	takeMoreThan: (Duration milliSeconds: 125)
	description: ''smallAmp'''
]

{ #category : #tests }
SAObservationTimeoutTest >> testBuildAssertions [
	| item |
	item := SAObservationTimeout forTimeout: 125.
	self assert: item buildAssertions class equals: OrderedCollection.
	self deny: item buildAssertions isEmpty
]

{ #category : #tests }
SAObservationTimeoutTest >> testInit [
	| item |
	item := SAObservationTimeout forTimeout: 125.
	self assert: item timeout equals: 125
]
