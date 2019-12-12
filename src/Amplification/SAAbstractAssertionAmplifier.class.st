Class {
	#name : #SAAbstractAssertionAmplifier,
	#superclass : #Object,
	#instVars : [
		'testMethodModel'
	],
	#category : #'Amplification-Core'
}

{ #category : #'as yet unclassified' }
SAAbstractAssertionAmplifier class >> assertionAmplify: aTestMethodModel [
	^ self new assertionAmplify: aTestMethodModel
]

{ #category : #'as yet unclassified' }
SAAbstractAssertionAmplifier >> assertionAmplifiedSourceCode [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SAAbstractAssertionAmplifier >> assertionAmplify: aTestMethodModel [
	testMethodModel := aTestMethodModel.
	^ self assertionAmplifiedSourceCode
]
