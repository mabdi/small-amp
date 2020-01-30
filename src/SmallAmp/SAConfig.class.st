Class {
	#name : #SAConfig,
	#superclass : #Object,
	#instVars : [
		'inputAmplifiers',
		'flackyTestRepeat',
		'assertionAmplifiers',
		'iterations',
		'debug',
		'lite',
		'selections',
		'oracleReducions',
		'profiler',
		'testRunTimeOut',
		'serializationMaxDepth'
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
SAConfig >> flackyTestRepeat [
	^ flackyTestRepeat
]

{ #category : #accessing }
SAConfig >> flackyTestRepeat: anObject [
	flackyTestRepeat := anObject
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
SAConfig >> oracleReducions [
	^ oracleReducions
]

{ #category : #accessing }
SAConfig >> oracleReducions: list [
	oracleReducions := list
]

{ #category : #accessing }
SAConfig >> profiler [
	^ profiler
]

{ #category : #accessing }
SAConfig >> profiler: anObject [
	profiler := anObject
]

{ #category : #accessing }
SAConfig >> selections [
	^ selections
]

{ #category : #accessing }
SAConfig >> selections: aListOfSelections [
	selections := aListOfSelections
]

{ #category : #accessing }
SAConfig >> serializationMaxDepth [
	^ serializationMaxDepth
]

{ #category : #accessing }
SAConfig >> serializationMaxDepth: anObject [
	serializationMaxDepth := anObject
]

{ #category : #accessing }
SAConfig >> testRunTimeOut [
	^ testRunTimeOut
]

{ #category : #accessing }
SAConfig >> testRunTimeOut: anObject [
	testRunTimeOut := anObject
]
