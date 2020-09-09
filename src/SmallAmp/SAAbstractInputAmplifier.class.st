Class {
	#name : #SAAbstractInputAmplifier,
	#superclass : #Object,
	#instVars : [
		'testMethodModel',
		'config'
	],
	#category : #'SmallAmp-Core'
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
	[ ^ self amplifyInputs ]
		on: Error
		do: [ :x | 
			config debug
				ifTrue: [ self halt ].
			^ {} ]
]

{ #category : #'as yet unclassified' }
SAAbstractInputAmplifier >> namingPrefix [
	^ self class name
]

{ #category : #removing }
SAAbstractInputAmplifier >> with: aConfig [
	config := aConfig
]
