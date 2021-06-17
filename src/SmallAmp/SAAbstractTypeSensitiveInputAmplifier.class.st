Class {
	#name : #SAAbstractTypeSensitiveInputAmplifier,
	#superclass : #SAAbstractInputAmplifier,
	#instVars : [
		'variableTypes'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #testing }
SAAbstractTypeSensitiveInputAmplifier >> isTypeSensitive [
	^ true
]

{ #category : #accessing }
SAAbstractTypeSensitiveInputAmplifier >> variableTypes [
	^ variableTypes
]

{ #category : #accessing }
SAAbstractTypeSensitiveInputAmplifier >> variableTypes: anObject [
	variableTypes := anObject
]
