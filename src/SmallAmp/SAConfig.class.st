Class {
	#name : #SAConfig,
	#superclass : #Object,
	#instVars : [
		'inputAmplifiers',
		'flackyTestRepeat',
		'assertionAmplifier',
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
		'mainloop',
		'hashClass',
		'ranking',
		'skipNonPretty',
		'ampNamesSuffix',
		'mutalkUseOriginalOperators'
	],
	#category : #'SmallAmp-Model'
}

{ #category : #accessing }
SAConfig class >> default [

	^ self dspotAllamps
		  maxPop: 200;
		  yourself
]

{ #category : #accessing }
SAConfig class >> diffBased [

	^ self new
		iterations: 3;
		ranking: false;
		  assertionAmplifier: SADiffAssertionAmplifier;
		  flackyTestRepeat: 10;
		  inputAmplifiers: { 
				  (SALiteralInputAmplifier -> 1).
				  (SARemoveInputAmplifier -> 1).
				  (SADuplicateInputAmplifier -> 1).
				  (SAAddInputAmplifier -> 1).
				  (SARotateLiteralsInputAmplifier -> 1).
				  (SAUniqLiteralsInputAmplifier -> 1).
				  (SAInstantiationTransplanter -> 1).
				  (SANullifyInputAmplifier -> 1) };
		  profiler: SAProxyProfiler new;
		  selection: SAMutationTestingDiffSelection;
		  oracleReducion: SANoOracleReduction;
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
		  ranking: false;
		  iterations: 3;
		  assertionAmplifier: SADspotAssertionAmplifier;
		  flackyTestRepeat: 3;
		  skipNonPretty: true;
		  inputAmplifiers: { 
				  (SALiteralInputAmplifier -> 1).
				  (SARemoveInputAmplifier -> 1).
				  (SADuplicateInputAmplifier -> 1).
				  (SAAddInputAmplifier -> 1).
				  (SARotateLiteralsInputAmplifier -> 1).
				  (SAUniqLiteralsInputAmplifier -> 1).
				  (SAInstantiationTransplanter -> 1).
				  (SANullifyInputAmplifier -> 1) };
		  profiler: SAProxyProfiler new;
		  selection: SADSpotSelection;
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
SAConfig class >> dspotOldamps [

	^ self dspotAllamps
		  inputAmplifiers: { 
				  (SALiteralInputAmplifier -> 1).
				  (SARemoveInputAmplifier -> 1).
				  (SADuplicateInputAmplifier -> 1).
				  (SAAddInputAmplifier -> 1) };
		  yourself
]

{ #category : #accessing }
SAConfig >> ampNamesSuffix [

	^ ampNamesSuffix
]

{ #category : #accessing }
SAConfig >> ampNamesSuffix: anObject [

	ampNamesSuffix := anObject
]

{ #category : #accessing }
SAConfig >> assertionAmplifier [
	^ assertionAmplifier
]

{ #category : #accessing }
SAConfig >> assertionAmplifier: aListOfClassNames [
	assertionAmplifier := aListOfClassNames
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
SAConfig >> mutalkUseOriginalOperators [

	^ mutalkUseOriginalOperators
]

{ #category : #accessing }
SAConfig >> mutalkUseOriginalOperators: anObject [

	mutalkUseOriginalOperators := anObject
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
SAConfig >> ranking [

	^ ranking
]

{ #category : #accessing }
SAConfig >> ranking: anObject [

	ranking := anObject
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
SAConfig >> skipNonPretty [

	^ skipNonPretty
]

{ #category : #accessing }
SAConfig >> skipNonPretty: anObject [

	skipNonPretty := anObject
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
