"
A SATestAssertionDensityTest is a test class for testing the behavior of SATestAssertionDensity
"
Class {
	#name : #SATestAssertionDensityTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Helpers'
}

{ #category : #tests }
SATestAssertionDensityTest >> testDensityMethod [
	| testMethod |
	testMethod := self class >> #testDensityMethod.
	self
		assert: (SATestAssertionDensity new densityForMethod: testMethod)
		equals: 1/2
]
