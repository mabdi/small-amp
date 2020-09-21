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
		'methodReductions',
		'prettifier',
		'simplifier',
		'maxPop',
		'testRunTimeOutMult',
		'saveToFile',
		'runSandboxed',
		'excludeList',
		'enableExclude',
		'overwrite',
		'timeBudget',
		'maxPopPerMethod',
		'mainloop',
		'waves'
	],
	#category : #'SmallAmp-Model'
}

{ #category : #accessing }
SAConfig class >> default [
	^ self twoWave 
]

{ #category : #accessing }
SAConfig class >> defaultSandboxed [
	| c |
	c := self default.
	c runSandboxed: true.
	^ c
]

{ #category : #accessing }
SAConfig class >> dspot [
	^ self new
		iterations: 5;
		assertionAmplifiers: {SADefaultAssertionAmplifier};
		flackyTestRepeat: 10;
		inputAmplifiers:
			{SADspotLiteralInputAmplifier.
			SAAddInputAmplifier};
		profiler: SAProxyProfiler new;
		selection: SAMutationCoverageSelection;
		methodReductions: {SANoMethodReduction};
		oracleReducion: SAMuTalkFirstFailOracleReduction;
		simplifier: SADefaultSimplification;
		prettifier: SADefaultPrettification;
		testRunTimeOut: 300000;
		testRunTimeOutMult: 5;
		statementTimeOut: 2000;
		maxPop: 200;
		maxPopPerMethod: 10;
		debug: false;
		mainloop: SAMainLoopDspot;
		saveToFile: false;
		runSandboxed: false;
		enableExclude: false;
		overwrite: false;
		excludeList: '../blacklist.txt';
		timeBudget: 21600;
		serializationMaxDepth: 3;
		yourself
]

{ #category : #accessing }
SAConfig class >> oneWave [
	^ self new
		iterations: 5;
		assertionAmplifiers: {SADefaultAssertionAmplifier};
		flackyTestRepeat: 10;
		inputAmplifiers:
			{SALiteralInputAmplifier.
			SAAddInputAmplifier.
			SARemoveInputAmplifier.
			SAUniqLiteralsInputAmplifier.
			SARotateLiteralsInputAmplifier};
		profiler: SAProxyProfiler new;
		selection: SAMutationCoverageSelection;
		methodReductions: {SAMaxPopMethodReduction};
		oracleReducion: SAMuTalkFirstFailOracleReduction;
		simplifier: SADefaultSimplification;
		prettifier: SADefaultPrettification;
		testRunTimeOut: 300000;
		testRunTimeOutMult: 5;
		statementTimeOut: 2000;
		maxPop: 200;
		maxPopPerMethod: 10;
		debug: false;
		mainloop: SAMainLoopOneWave;
		saveToFile: false;
		runSandboxed: false;
		enableExclude: false;
		overwrite: false;
		excludeList: '../blacklist.txt';
		timeBudget: 21600;
		serializationMaxDepth: 3;
		yourself
]

{ #category : #accessing }
SAConfig class >> smallAmp [
	^ self new
		iterations: 5;
		assertionAmplifiers: {SADefaultAssertionAmplifier};
		flackyTestRepeat: 10;
		inputAmplifiers:
			{SALiteralInputAmplifier.
			SAAddInputAmplifier.
			SARemoveInputAmplifier.
			SAUniqLiteralsInputAmplifier.
			SARotateLiteralsInputAmplifier.
			SAInstantiationTransplanter};
		profiler: SAProxyProfiler new;
		selection: SAMutationCoverageSelection;
		methodReductions: {SAMaxPopMethodReduction};
		oracleReducion: SANoOracleReduction;
		simplifier: SADefaultSimplification;
		prettifier: SADefaultPrettification;
		testRunTimeOut: 300000;
		testRunTimeOutMult: 5;
		statementTimeOut: 2000;
		maxPop: 200;
		waves: 3;
		maxPopPerMethod: 50;
		debug: true;
		mainloop: SAMainLoopSmallAmp;
		saveToFile: false;
		runSandboxed: false;
		enableExclude: false;
		overwrite: false;
		excludeList: '../blacklist.txt';
		timeBudget: 21600;
		serializationMaxDepth: 3;
		yourself
]

{ #category : #accessing }
SAConfig class >> twoWave [
	^ self new
		iterations: 5;
		assertionAmplifiers: {SADefaultAssertionAmplifier};
		flackyTestRepeat: 10;
		inputAmplifiers:
			{SALiteralInputAmplifier.
			SAAddInputAmplifier.
			SARemoveInputAmplifier.
			SAUniqLiteralsInputAmplifier.
			SARotateLiteralsInputAmplifier};
		profiler: SAProxyProfiler new;
		selection: SAMutationCoverageSelection;
		methodReductions: {SAMaxPopMethodReduction};
		oracleReducion: SAMuTalkFirstFailOracleReduction;
		simplifier: SADefaultSimplification;
		prettifier: SADefaultPrettification;
		testRunTimeOut: 300000;
		testRunTimeOutMult: 5;
		statementTimeOut: 2000;
		maxPop: 200;
		maxPopPerMethod: 50;
		debug: false;
		mainloop: SAMainLoopTwoWave;
		saveToFile: false;
		runSandboxed: false;
		enableExclude: false;
		overwrite: false;
		excludeList: '../blacklist.txt';
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

{ #category : #accessing }
SAConfig >> enableExclude [
	^ enableExclude
]

{ #category : #accessing }
SAConfig >> enableExclude: anObject [
	enableExclude := anObject
]

{ #category : #accessing }
SAConfig >> excludeList [
	^ excludeList
]

{ #category : #accessing }
SAConfig >> excludeList: anObject [
	excludeList := anObject
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
SAConfig >> maxPopPerMethod [
	^ maxPopPerMethod
]

{ #category : #accessing }
SAConfig >> maxPopPerMethod: anObject [
	maxPopPerMethod := anObject
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
	^ oracleReducion ifNil: [ selection defaultOracleReduction ]
]

{ #category : #accessing }
SAConfig >> oracleReducion: list [
	oracleReducion := list
]

{ #category : #accessing }
SAConfig >> overwrite [
	^ overwrite
]

{ #category : #accessing }
SAConfig >> overwrite: anObject [
	overwrite := anObject
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
SAConfig >> runSandboxed [
	^ runSandboxed
]

{ #category : #accessing }
SAConfig >> runSandboxed: anObject [
	runSandboxed := anObject
]

{ #category : #accessing }
SAConfig >> saveToFile [
	^ saveToFile
]

{ #category : #accessing }
SAConfig >> saveToFile: anObject [
	saveToFile := anObject
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

{ #category : #accessing }
SAConfig >> waves [
	^ waves
]

{ #category : #accessing }
SAConfig >> waves: anObject [
	waves := anObject
]
