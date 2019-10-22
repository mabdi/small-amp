Class {
	#name : #AbstractAssertAmplifier,
	#superclass : #Object,
	#category : #'Amplification-Core'
}

{ #category : #'as yet unclassified' }
AbstractAssertAmplifier >> assertionAmplify: aMethod [
	^ aMethod
		testMethodModified:
			(self
				doAssertionAmplification: aMethod testMethodModified
				within: aMethod testClass
				)
]

{ #category : #'as yet unclassified' }
AbstractAssertAmplifier >> doAssertAmplification: population amplifier: anAmplifier [
		^ population
		collect: [ :tcase | self assertionAmplify: tcase ]
		displayingProgress: 'Assert amplifying'
]

{ #category : #'as yet unclassified' }
AbstractAssertAmplifier >> doAssertionAmplification: aMethod within: atestClass [
	self subclassResponsibility 
]
