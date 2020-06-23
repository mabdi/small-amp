Class {
	#name : #SATestAssertionDensity,
	#superclass : #Object,
	#category : #'SmallAmp-Helpers'
}

{ #category : #'as yet unclassified' }
SATestAssertionDensity class >> dencityFor: methods [
	methods ifEmpty: [ ^ 0 ].
	^ ((methods
		collect: [ :m | self new densityForMethod: m ])
		inject: 0
		into: [ :s :i | s + i ]) / methods size
		printShowingDecimalPlaces: 2
]

{ #category : #'as yet unclassified' }
SATestAssertionDensity >> densityForClass: aTestClass [
	^ (aTestClass methods
		select: #isTestMethod
		thenCollect: [ :x | self numberOfAssertionsInMethod: x ]) average 
]

{ #category : #'as yet unclassified' }
SATestAssertionDensity >> densityForMethod: aTestMethod [
	aTestMethod ast statements 
		ifEmpty: [ ^ 0 ].
	^ (self numberOfAssertionsInMethod: aTestMethod)
		/ aTestMethod ast statements size
]

{ #category : #'as yet unclassified' }
SATestAssertionDensity >> numberOfAssertionsInMethod: aTestMethod [
	^ SAAssertTransform new numberOfAssertionsIn: aTestMethod ast
]
