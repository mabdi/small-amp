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
		'oracleReducion',
		'profiler',
		'statementTimeOut',
		'testRunTimeOut',
		'serializationMaxDepth',
		'methodReductions',
		'prettifier',
		'simplifier'
	],
	#category : #'SmallAmp-Model'
}

{ #category : #accessing }
SAConfig class >> default [
	^ SAConfig new
		iterations: 3;
		assertionAmplifiers: {SADefaultAssertionAmplifier};
		flackyTestRepeat: 3;
		inputAmplifiers:
			{SALiteralInputAmplifier.
			SAAddInputAmplifier};
		profiler: SAProxyProfiler new;
		selections: {SAMutationCoverageSelection};
		methodReductions: {SANoMethodReduction};
		oracleReducion: SAMuTalkFirstFailOracleReduction;
		simplifier: SADefaultSimplification;
		prettifier: SADefaultPrettification;
		testRunTimeOut: 10000;
		statementTimeOut: 2000;
		debug: false;
		lite: false;
		yourself
]

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
SAConfig >> methodReductions [
	^ methodReductions
]

{ #category : #accessing }
SAConfig >> methodReductions: anObject [
	methodReductions := anObject
]

{ #category : #accessing }
SAConfig >> oracleReducion [
	^ oracleReducion
]

{ #category : #accessing }
SAConfig >> oracleReducion: list [
	oracleReducion := list
]

{ #category : #accessing }
SAConfig >> prettifier [
	^ prettifier
]

{ #category : #accessing }
SAConfig >> prettifier: anObject [
	prettifier := anObject
]

{ #category : #accessing }
SAConfig >> profiler [
	^ profiler
]

{ #category : #accessing }
SAConfig >> profiler: anObject [
	profiler := anObject.
	profiler config: self
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
SAConfig >> simplifier [
	^ simplifier
]

{ #category : #accessing }
SAConfig >> simplifier: anObject [
	simplifier := anObject
]

{ #category : #accessing }
SAConfig >> statementTimeOut [
	^ statementTimeOut
]

{ #category : #accessing }
SAConfig >> statementTimeOut: anInt [
	statementTimeOut:= anInt
]

{ #category : #accessing }
SAConfig >> testRunTimeOut [
	^ testRunTimeOut
]

{ #category : #accessing }
SAConfig >> testRunTimeOut: anObject [
	testRunTimeOut := anObject
]
