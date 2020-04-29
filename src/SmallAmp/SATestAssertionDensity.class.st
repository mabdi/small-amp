Class {
	#name : #SATestAssertionDensity,
	#superclass : #Object,
	#category : #'SmallAmp-Helpers'
}

{ #category : #'as yet unclassified' }
SATestAssertionDensity >> densityForClass: aTestClass [
	^ (aTestClass methods
		select: #isTestMethod
		thenCollect: [ :x | self numberOfAssertionsInMethod: x ]) average 
]

{ #category : #'as yet unclassified' }
SATestAssertionDensity >> densityForMethod: aTestMethod [
	^ (self numberOfAssertionsInMethod: aTestMethod)
		/ aTestMethod ast statements size
]

{ #category : #'as yet unclassified' }
SATestAssertionDensity >> numberOfAssertionsInMethod: aTestMethod [
	^ SAAssertTransform new numberOfAssertionsIn: aTestMethod ast
]
