"
A SAObservationItemTest is a test class for testing the behavior of SAObservationItem
"
Class {
	#name : #SAObservationItemTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Model'
}

{ #category : #tests }
SAObservationItemTest >> testBuildAssertionType [
	| item |
	item := SAObservationPrimitive newForClass: SmallInteger values: 1.
	item name: 'foo'.
	self
		assert: item buildAssertionType formattedCode
		equals:
		'self assert: foo class equals: SmallInteger description: ''smallAmp'''
]
