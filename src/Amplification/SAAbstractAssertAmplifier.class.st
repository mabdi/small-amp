Class {
	#name : #SAAbstractAssertAmplifier,
	#superclass : #Object,
	#instVars : [
		'theAmplifier'
	],
	#category : #'Amplification-Core'
}

{ #category : #'as yet unclassified' }
SAAbstractAssertAmplifier >> assertionAmplify: aMethod [
	^ aMethod
		testMethodModified:
			(self
				doAssertionAmplification: aMethod testMethodModified
				within: aMethod testClass
				)
]

{ #category : #'as yet unclassified' }
SAAbstractAssertAmplifier >> doAssertAmplification: population amplifier: anAmplifier [
	theAmplifier := anAmplifier.
	^ population
		collect: [ :tcase | self assertionAmplify: tcase ]
		displayingProgress: 'Assert amplifying'
]

{ #category : #'as yet unclassified' }
SAAbstractAssertAmplifier >> doAssertionAmplification: aMethod within: atestClass [
	self subclassResponsibility 
]
