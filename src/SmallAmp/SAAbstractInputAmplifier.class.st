Class {
	#name : #SAAbstractInputAmplifier,
	#superclass : #Object,
	#instVars : [
		'testMethodModel',
		'config'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SAAbstractInputAmplifier class >> findInputAmplifierWithPostfix: aPostfix [

	^ self allSubclasses
		  detect: [ :cls | cls namingPostfix = aPostfix ]
		  ifNone: [ ^ nil ]
]

{ #category : #removing }
SAAbstractInputAmplifier class >> initializeWith: aConfig [
	^ self new
		  with: aConfig
]

{ #category : #'as yet unclassified' }
SAAbstractInputAmplifier class >> namingPostfix [

	^ self name
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
			SmallAmp <~ ('SmallAmp debug info: ',self class name ,'>>amplifyInputsFor: , Exception is skipped: ',x class name, '-> ', x description, '-> ', aTestMethodModel selector).
			config debug ifTrue: [ self halt ].
			^ {  } ]
]

{ #category : #testing }
SAAbstractInputAmplifier >> isTransplantation [
	^ false
]

{ #category : #testing }
SAAbstractInputAmplifier >> isTypeSensitive [
	^ false
]

{ #category : #'as yet unclassified' }
SAAbstractInputAmplifier >> namingPostfix [

	^ self class namingPostfix
]

{ #category : #removing }
SAAbstractInputAmplifier >> with: aConfig [
	config := aConfig
]
