Class {
	#name : #SAAbstractAssertionAmplifier,
	#superclass : #Object,
	#instVars : [
		'testMethodModel',
		'config'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SAAbstractAssertionAmplifier class >> initializeWith: aConfig [
	^ self new
		  with: aConfig
]

{ #category : #'as yet unclassified' }
SAAbstractAssertionAmplifier >> allOpenedWindows [
	^  SystemWindow allInstances, GLMSystemWindow allInstances.
]

{ #category : #'as yet unclassified' }
SAAbstractAssertionAmplifier >> amplifyAssertions [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SAAbstractAssertionAmplifier >> amplifyAssertionsFor: aTestModel [
	testMethodModel := aTestModel.
	^ self amplifyAssertions
]

{ #category : #'as yet unclassified' }
SAAbstractAssertionAmplifier >> closeAllWindowsBut: openWindows [
| actualWindows |
	actualWindows := self allOpenedWindows.
	(actualWindows copyWithoutAll: openWindows) do: #delete
]

{ #category : #initialization }
SAAbstractAssertionAmplifier >> with: aConfig [
	self initialize.
	config := aConfig
]
