Class {
	#name : #SAAbstractAssertAmplifier,
	#superclass : #Object,
	#instVars : [
		'testMethodModel'
	],
	#category : #'Amplification-Core'
}

{ #category : #'as yet unclassified' }
SAAbstractAssertAmplifier class >> assertionAmplify: aTestMethodModel [
	^ self new assertionAmplify: aTestMethodModel
]

{ #category : #'as yet unclassified' }
SAAbstractAssertAmplifier >> assertionAmplifiedSourceCode [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SAAbstractAssertAmplifier >> assertionAmplify: aTestMethodModel [
	testMethodModel := aTestMethodModel.
	^ self assertionAmplifiedSourceCode
]
