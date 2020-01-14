Class {
	#name : #SAConfig,
	#superclass : #Object,
	#instVars : [
		'inputAmplifiers',
		'assertionAmplifiers',
		'iterations',
		'debug',
		'lite',
		'logger',
		'selections',
		'minifiers'
	],
	#category : #'SmallAmp-Model'
}

{ #category : #accessing }
SAConfig >> assertionAmplifiers [
	^ assertionAmplifiers
]

{ #category : #accessing }
SAConfig >> assertionAmplifiers: aListOfClassNames [
	assertionAmplifiers := aListOfClassNames
]

{ #category : #accessing }
SAConfig >> debug [
	^ debug ifNil: [ debug := false ]
]

{ #category : #accessing }
SAConfig >> debug: anObject [
	debug := anObject
]

{ #category : #accessing }
SAConfig >> inputAmplifiers [
	^ inputAmplifiers
]

{ #category : #accessing }
SAConfig >> inputAmplifiers: anObject [
	inputAmplifiers := anObject
]

{ #category : #accessing }
SAConfig >> iterations [
	^ iterations ifNil: [ iterations:= 3 ]
]

{ #category : #accessing }
SAConfig >> iterations: anObject [
	iterations := anObject
]

{ #category : #accessing }
SAConfig >> lite [
	^ lite ifNil: [ lite:= false ]
]

{ #category : #accessing }
SAConfig >> lite: anObject [
	lite := anObject
]

{ #category : #accessing }
SAConfig >> logger [
	^ logger
]

{ #category : #accessing }
SAConfig >> logger: anObject [
	logger := anObject
]

{ #category : #accessing }
SAConfig >> minifiers [
	^ minifiers
]

{ #category : #accessing }
SAConfig >> minifiers: list [
	minifiers := list
]

{ #category : #accessing }
SAConfig >> selections [
	^ selections
]

{ #category : #accessing }
SAConfig >> selections: aListOfSelections [
	selections := aListOfSelections
]
