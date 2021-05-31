Class {
	#name : #SAConfig,
	#superclass : #Object,
	#instVars : [
		'inputAmplifiers',
		'flackyTestRepeat',
		'assertionAmplifiers',
		'iterations',
		'debug',
		'selection',
		'oracleReducion',
		'profiler',
		'statementTimeOut',
		'testRunTimeOut',
		'serializationMaxDepth',
		'prettifier',
		'maxPop',
		'testRunTimeOutMult',
		'timeBudget',
		'mainloop'
	],
	#category : #'SmallAmp-Model'
}

{ #category : #accessing }
SAConfig class >> default [
	^ self dspotAllamps
		maxPop: 10;
		yourself
]

{ #category : #accessing }
SAConfig class >> dspot [
	^ self new
		iterations: 3;
		assertionAmplifiers: {SADefaultAssertionAmplifier};
		flackyTestRepeat: 10;
		inputAmplifiers:
			{(SALiteralInputAmplifier -> 1).
			(SARemoveInputAmplifier -> 1).
			(SADuplicateInputAmplifier -> 1).
			(SAAddInputAmplifier -> 1)};
		profiler: SAProxyProfiler new;
		selection: SAMutationCoverageDSpotSelection;
		oracleReducion: SAMuTalkFirstFailOracleReduction;
		prettifier: SADefaultPrettification;
		testRunTimeOut: 300000;
		testRunTimeOutMult: 5;
		statementTimeOut: 2000;
		maxPop: 100;
		debug: false;
		mainloop: SAMainLoopDspot;
		timeBudget: 21600;
		serializationMaxDepth: 3;
		yourself
]

{ #category : #accessing }
SAConfig class >> dspotAllamps [
	^ self new
		iterations: 3;
		assertionAmplifiers: {SADefaultAssertionAmplifier};
		flackyTestRepeat: 10;
		inputAmplifiers:
			{(SALiteralInputAmplifier -> 1).
			(SARemoveInputAmplifier -> 1).
			(SADuplicateInputAmplifier -> 1).
			(SAAddInputAmplifier -> 1).
			(SARotateLiteralsInputAmplifier -> 1).
			(SAUniqLiteralsInputAmplifier -> 1).
			(SAInstantiationTransplanter -> 1).
			(SANullifyInputAmplifier -> 1)};
		profiler: SAProxyProfiler new;
		selection: SAMutationCoverageDSpotSelection;
		oracleReducion: SAMuTalkFirstFailOracleReduction;
		prettifier: SADefaultPrettification;
		testRunTimeOut: 300000;
		testRunTimeOutMult: 5;
		statementTimeOut: 2000;
		maxPop: 100;
		debug: false;
		mainloop: SAMainLoopDspot;
		timeBudget: 21600;
		serializationMaxDepth: 3;
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

{ #category : #'as yet unclassified' }
SAConfig >> debugOn [
	self debug: true
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
SAConfig >> mainloop [
	^ mainloop
]

{ #category : #accessing }
SAConfig >> mainloop: anObject [
	mainloop := anObject
]

{ #category : #accessing }
SAConfig >> maxPop [
	^ maxPop
]

{ #category : #accessing }
SAConfig >> maxPop: anObject [
	maxPop := anObject
]

{ #category : #accessing }
SAConfig >> oracleReducion [
	^ oracleReducion ifNil: [ selection defaultOracleReduction ]
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
SAConfig >> selection [
	^ selection
]

{ #category : #accessing }
SAConfig >> selection: aSelectionClass [
	selection := aSelectionClass
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

{ #category : #accessing }
SAConfig >> testRunTimeOutMult [
	^ testRunTimeOutMult
]

{ #category : #accessing }
SAConfig >> testRunTimeOutMult: anObject [
	testRunTimeOutMult := anObject
]

{ #category : #accessing }
SAConfig >> timeBudget [
	^ timeBudget
]

{ #category : #accessing }
SAConfig >> timeBudget: anObject [
	timeBudget := anObject
]
