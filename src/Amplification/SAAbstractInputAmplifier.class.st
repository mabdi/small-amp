Class {
	#name : #SAAbstractInputAmplifier,
	#superclass : #Object,
	#instVars : [
		'testMethodModel',
		'config'
	],
	#category : #'Amplification-Core'
}

{ #category : #removing }
SAAbstractInputAmplifier class >> initializeWith: aConfig [
	^ self new
		  with: aConfig
]

{ #category : #removing }
SAAbstractInputAmplifier >> amplifyInputs [
	^ self subclassResponsibility 
]

{ #category : #removing }
SAAbstractInputAmplifier >> amplifyInputsFor: aTestMethodModel [
	testMethodModel := aTestMethodModel.
	^ self amplifyInputs
]

{ #category : #removing }
SAAbstractInputAmplifier >> with: aConfig [
	config := aConfig
]
