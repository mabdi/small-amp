Class {
	#name : #SAAbstractInputAmplifier,
	#superclass : #Object,
	#instVars : [
		'testMethodModel'
	],
	#category : #'Amplification-Core'
}

{ #category : #removing }
SAAbstractInputAmplifier class >> inputAmplify: aTestMethodModel [
	^ self new with: aTestMethodModel; amplifyInputs
]

{ #category : #removing }
SAAbstractInputAmplifier >> amplifyInputs [
	^ self subclassResponsibility 
]

{ #category : #removing }
SAAbstractInputAmplifier >> with: aMethodModel [
	testMethodModel := aMethodModel
]
