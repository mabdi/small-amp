Class {
	#name : #SAConfig,
	#superclass : #Object,
	#instVars : [
		'inputAmplifiers',
		'assertAmplifiers',
		'selectors',
		'iterations',
		'debug',
		'lite',
		'logger'
	],
	#category : #'Amplification-Model'
}

{ #category : #accessing }
SAConfig >> assertAmplifiers [
	^ assertAmplifiers
]

{ #category : #accessing }
SAConfig >> assertAmplifiers: anObject [
	assertAmplifiers := anObject
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
	^ lite
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
	^ selectors
]

{ #category : #accessing }
SAConfig >> selectors: anObject [
	selectors := anObject
]
