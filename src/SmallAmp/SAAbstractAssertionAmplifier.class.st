Class {
	#name : #SAAbstractAssertionAmplifier,
	#superclass : #Object,
	#instVars : [
		'testMethodModel',
		'config',
		'testRunTimeoutMillis'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SAAbstractAssertionAmplifier class >> initializeWith: aConfig [
	^ self new
		  with: aConfig
]

{ #category : #'as yet unclassified' }
SAAbstractAssertionAmplifier >> amplifyAssertions [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SAAbstractAssertionAmplifier >> amplifyAssertionsFor: aTestModel [
	testMethodModel := aTestModel.
	[ ^ self amplifyAssertions ]
		on: Error
		do: [ :x | config debug ifTrue: [self halt]. ^ nil ]
]

{ #category : #accessing }
SAAbstractAssertionAmplifier >> testRunTimeoutMillis: anObject [
	testRunTimeoutMillis := anObject
]

{ #category : #initialization }
SAAbstractAssertionAmplifier >> with: aConfig [
	self initialize.
	config := aConfig
]
