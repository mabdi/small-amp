Class {
	#name : #SAConfig,
	#superclass : #Object,
	#instVars : [
		'inputAmplifiers',
		'assertionAmplifiers',
		'selectors',
		'iterations',
		'debug',
		'lite',
		'logger'
	],
	#category : #'Amplification-Model'
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
	^ debug
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
	^ iterations
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
SAConfig >> selectors [
	self flag: #TODO. "rename from selector. because selector is the name of method. use selection or sth"
	^ selectors
]

{ #category : #accessing }
SAConfig >> selectors: anObject [
	selectors := anObject
]
