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
	^ self new
		  with: aTestMethodModel;
		  amplifyAssertions
]

{ #category : #'as yet unclassified' }
SAAbstractAssertionAmplifier >> amplifyAssertions [
	^ self subclassResponsibility
]

{ #category : #initialization }
SAAbstractAssertionAmplifier >> with: aTestMethodModel [
	self initialize.
	testMethodModel := aTestMethodModel
]
