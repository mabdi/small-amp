Class {
	#name : #SAResultItem,
	#superclass : #Object,
	#instVars : [
		'failedSelectorInOriginal',
		'amplifiedClassInitial',
		'amplifiedClass',
		'amplifiedAnalysis',
		'targetClasses',
		'testClass',
		'originalAnalysis',
		'runProfile',
		'amplifiedCoverage',
		'originalCoverage',
		'timeBudgetFinished',
		'numberOfOriginalTestMethods',
		'totalTime',
		'numberOfProcessedMethods',
		'testClassTimeToRunInMillis',
		'oracleReductionReverts',
		'amplifiedMethods'
	],
	#category : #'SmallAmp-Model'
}

{ #category : #'as yet unclassified' }
SAResultItem class >> forAmplified: newTest original: theOriginal target: targets [
	^ self new
		testClass: theOriginal;
		amplifiedClass: newTest;
		targetClasses: targets;
		regenerate;
		yourself
]

{ #category : #'as yet unclassified' }
SAResultItem class >> forAmplified: newTest original: theOriginal target: targets profiler: aProfiler [
	aProfiler profileClasses: targets byRunning: theOriginal.
	
	^ self new
		testClass: theOriginal;
		amplifiedClass: newTest;
		targetClasses: targets;
		runProfile: aProfiler;
		regenerate;
		yourself
]

{ #category : #'instance creation' }
SAResultItem class >> fromDictionaryObject: aJsonObj [
	^ self
		forAmplified: ((aJsonObj at: #amplifiedClass) asClass )
		original: ( (aJsonObj at: #testCase) asClass )
		target:
			((aJsonObj at: #targetClasses)
				collect: #asClass)
]

{ #category : #accessing }
SAResultItem >> amplifiedAnalysis [

	^ amplifiedAnalysis ifNotNil: [ amplifiedAnalysis ] ifNil: [ originalAnalysis  ]
]

{ #category : #accessing }
SAResultItem >> amplifiedAnalysis: anObject [
	amplifiedAnalysis := anObject
]

{ #category : #accessing }
SAResultItem >> amplifiedClass [
	^ amplifiedClass
]

{ #category : #accessing }
SAResultItem >> amplifiedClass: anObject [
	amplifiedClass := anObject
]

{ #category : #accessing }
SAResultItem >> amplifiedClassInitial [

	^ amplifiedClassInitial
]

{ #category : #accessing }
SAResultItem >> amplifiedClassInitial: anObject [

	amplifiedClassInitial := anObject
]

{ #category : #reporting }
SAResultItem >> amplifiedMethods [

  ^ amplifiedMethods
]

{ #category : #accessing }
SAResultItem >> amplifiedMethods: anObject [

	amplifiedMethods := anObject
]

{ #category : #reporting }
SAResultItem >> amplifiedMethodsAssertionDensity [
	self amplifiedMethods ifEmpty: [ ^ 0 ].
	^ amplifiedClass smallAmpAssertionDensity 
]

{ #category : #reporting }
SAResultItem >> amplifiedScore [

	^ self amplifiedAnalysis smallAmpScore

]

{ #category : #reporting }
SAResultItem >> amplifiedTestCoverage [
	amplifiedCoverage
		ifNil: [ amplifiedCoverage := SACoverageAnalyser new
				classes: targetClasses;
				testCases: {amplifiedClass };
				run ].
	^ amplifiedCoverage
]

{ #category : #reporting }
SAResultItem >> asDictionaryObject [

	| result |
	result := Dictionary new.
	result at: #unixtime put: DateAndTime now asUnixTime.
	self safeFail: [ testClass name ] key: #testCase addTo: result.
	self
		safeFail: [ testClass smallAmpOriginalTestCase name ]
		key: #originalTestCase
		addTo: result.
	self
		safeFail: [ (targetClasses collect: #name) asArray ]
		key: #targetClasses
		addTo: result.
	self
		safeFail: [ self amplifiedClass name ]
		key: #amplifiedClass
		addTo: result.
	self
		safeFail: [ self amplifiedMethods  ]
		key: #amplifiedMethods
		addTo: result.
	self
		safeFail: [ self originalScore ]
		key: #mutationScoreBefore
		addTo: result.
	self
		safeFail: [ self amplifiedScore ]
		key: #mutationScoreAfter
		addTo: result.
	self
		safeFail: [ self totalTime asSeconds ]
		key: #timeTotal
		addTo: result.
	self
		safeFail: [ 
			(targetClasses collect: [ :c | c linesOfCode + c class linesOfCode ])
				inject: 0
				into: [ :accum :each | accum + each ] ]
		key: #targetLoc
		addTo: result.
	self
		safeFail: [ testClass linesOfCode asString ]
		key: #testLoc
		addTo: result.
	self
		safeFail: [ 
			(self amplifiedMethods collect: #linesOfCode)
				inject: 0
				into: [ :accum :each | accum + each ] ]
		key: #testAmpLoc
		addTo: result.
	self
		safeFail: [ self timeBudgetFinished ]
		key: #timeBudgetFinished
		addTo: result.
	self
		safeFail: [ (self methodsNotProfiled collect: #name) asArray ]
		key: #methodsNotProfiled
		addTo: result.

	self
		safeFail: [ (self failedSelectorInOriginal collect: #name) asArray ]
		key: #testMethodsIgnored
		addTo: result.
	self
		safeFail: [ self numberOfAllMutationsInOriginal ]
		key: #numberOfAllMutationsInOriginal
		addTo: result.
	self
		safeFail: [ 
			(self notCoveredInOriginal collect: [ :m | 
				 m mutant asDictionaryObject ]) asArray ]
		key: #notCoveredInOriginal
		addTo: result.
	self
		safeFail: [ 
			(self newCovered collect: [ :m | m mutant asDictionaryObject ])
				asArray ]
		key: #newCovered
		addTo: result.
	self
		safeFail: [ 
			(self notCoveredInAmplified collect: [ :m | 
				 m mutant asDictionaryObject ]) asArray ]
		key: #notCoveredInAmplified
		addTo: result.
	self
		safeFail: [ self numberOfOriginalTestMethods ]
		key: #numberOfOriginalTestMethods
		addTo: result.
	self
		safeFail: [ self numberOfTestMethodsBeforeShreding ]
		key: #numberOfTestMethodsBeforeShreding
		addTo: result.
	self
		safeFail: [ self testClassTimeToRunInMillis ]
		key: #testClassTimeToRunInMillis
		addTo: result.
	self
		safeFail: [ self oracleReductionReverts ]
		key: #oracleReductionReverts
		addTo: result.
	self
		safeFail: [ self numberOfProcessedMethods ]
		key: #numberOfProcessedMethods
		addTo: result.
	^ result
]

{ #category : #export }
SAResultItem >> asFileText [
	^ STONJSON toStringPretty: self asDictionaryObject 
]

{ #category : #reporting }
SAResultItem >> directTestingOriginal [
	| dict vals |
	testClass allTestSelectors ifEmpty: [ ^ 0 ].
	dict := (SAReceiverTypeProfiler initializeWith: SAConfig default)
		testClass: testClass;
		testTargets: testClass smallAmpTargetClasses;
		run.
	vals := dict directCalls values.
	vals
		ifEmpty: [ ^ 0 ]
		ifNotEmpty: [ ^ vals sum / testClass allTestSelectors size ]
]

{ #category : #accessing }
SAResultItem >> failedSelectorInOriginal [
	^ failedSelectorInOriginal
]

{ #category : #accessing }
SAResultItem >> failedSelectorInOriginal: aListOfFaileds [
	failedSelectorInOriginal := aListOfFaileds 
]

{ #category : #initialization }
SAResultItem >> initialize [
	timeBudgetFinished := false
]

{ #category : #reporting }
SAResultItem >> markDownOn: stream [

	stream
		nextPutAll: '|';
		nextPutAll: testClass name;
		nextPutAll: '|';
		nextPutAll: (', ' join: (targetClasses collect: #name));
		nextPutAll: '|';
		nextPutAll: (Duration seconds: (self totalTime / 1000) asInteger)
				humanReadablePrintString;
		nextPutAll: '|'.
	self markDownOn: stream class: testClass analysis: originalAnalysis.
	stream nextPutAll: '|'.
	self
		markDownOn: stream
		class: amplifiedClass
		analysis: self amplifiedAnalysis.
	stream nextPutAll: '|'
]

{ #category : #private }
SAResultItem >> markDownOn: stream class: theClass analysis: analysis [
	self flag: #todo.
	stream nextPutAll: '#TestMethods: '.
	stream nextPutAll: theClass methods size asString.
	stream nextPutAll: '<br>'.
	stream nextPutAll: '#AllMutations: '.
	stream
		nextPutAll: analysis generalResult numberOfEvaluatedMutants asString.
	stream nextPutAll: '<br>'.
	stream nextPutAll: '#KilledMutants: '.
	stream
		nextPutAll: analysis generalResult numberOfKilledOrTerminatedMutants asString.
	stream nextPutAll: '<br>'.
	stream nextPutAll: 'Score: %'.
	stream nextPutAll: analysis generalResult mutationScore asString
]

{ #category : #reporting }
SAResultItem >> markDownTitleOn: stream [
	stream
		nextPutAll: '|';
		nextPutAll: 'TestCase';
		nextPutAll: '|';
		nextPutAll: 'TestTargets';
		nextPutAll: '|';
		nextPutAll: 'Running Time';
		nextPutAll: '|';
		nextPutAll: 'Originial';
		nextPutAll: '|'.
	stream
		nextPutAll: 'Amplified';
		nextPutAll: '|';
		cr.
	stream
		nextPutAll: '|';
		nextPutAll: '---';
		nextPutAll: '|';
		nextPutAll: '---';
		nextPutAll: '|';
		nextPutAll: '---';
		nextPutAll: '|';
		nextPutAll: '----';
		nextPutAll: '|'.
	stream
		nextPutAll: '----';
		nextPutAll: '|';
		cr
]

{ #category : #reporting }
SAResultItem >> methodsNotProfiled [
	| keys |
	self runProfile ifNil: [ ^ {} ].
	keys := self runProfile profile keys
		select: [ :p | 
			self targetClasses
				anySatisfy:
					[ :t | (p beginsWith: '#' , t name) | (p beginsWith: '#' , t class name) ] ].
	
	^ self targetClasses
		flatCollect: [ :c | 
			(c methods , c class methods
				select: [ :m | m selector includesSubstring: ':' ])
				reject: [ :m | 
					keys
						anySatisfy: [ :k | 
							(k beginsWith: '#' , c name , '#' , m selector)
								| (k beginsWith: '#' , c class name , '#' , m selector) ] ] ]
]

{ #category : #reporting }
SAResultItem >> newCovered [

	^ self amplifiedAnalysis smallAmpNewCovered: originalAnalysis
]

{ #category : #reporting }
SAResultItem >> notCoveredInAmplified [

	^ self amplifiedAnalysis smallAmpUncovered
]

{ #category : #reporting }
SAResultItem >> notCoveredInOriginal [
	^ self originalAnalysis smallAmpUncovered
]

{ #category : #reporting }
SAResultItem >> numberOfAllMutationsInOriginal [
	^ self originalAnalysis generalResult numberOfEvaluatedMutants
]

{ #category : #accessing }
SAResultItem >> numberOfOriginalTestMethods [
	^ numberOfOriginalTestMethods
]

{ #category : #accessing }
SAResultItem >> numberOfOriginalTestMethods: anObject [
	numberOfOriginalTestMethods := anObject
]

{ #category : #accessing }
SAResultItem >> numberOfProcessedMethods [

	^ numberOfProcessedMethods
]

{ #category : #accessing }
SAResultItem >> numberOfProcessedMethods: anObject [

	numberOfProcessedMethods := anObject
]

{ #category : #'as yet unclassified' }
SAResultItem >> numberOfTestMethodsBeforeShreding [

	^ testClass smallAmpOriginalTestCase testSelectors size
]

{ #category : #accessing }
SAResultItem >> oracleReductionReverts [

	^ oracleReductionReverts
]

{ #category : #accessing }
SAResultItem >> oracleReductionReverts: anObject [

	oracleReductionReverts := anObject
]

{ #category : #accessing }
SAResultItem >> originalAnalysis [
	^ originalAnalysis
]

{ #category : #accessing }
SAResultItem >> originalAnalysis: anObject [
	originalAnalysis := anObject
]

{ #category : #reporting }
SAResultItem >> originalMethods [
	^ self testClass methods select: #isTestMethod 
]

{ #category : #reporting }
SAResultItem >> originalMethodsAssertionDensity [
	self originalMethods ifEmpty: [ ^ 0 ].
	^ testClass smallAmpAssertionDensity 
]

{ #category : #reporting }
SAResultItem >> originalScore [
	^ originalAnalysis smallAmpScore 
]

{ #category : #reporting }
SAResultItem >> originalTestCoverage [
	originalCoverage
		ifNil: [ originalCoverage := SACoverageAnalyser new
				classes: targetClasses;
				testCases: {testClass};
				run ].
	^ originalCoverage
]

{ #category : #'as yet unclassified' }
SAResultItem >> regenerate: selection [
	self failedSelectorInOriginal: testClass smallAmpTestsToIgnore.
	self
		amplifiedAnalysis:
			(selection
				analysisFor: {amplifiedClass}
				targets: targetClasses
				ignore: failedSelectorInOriginal).
	self originalAnalysis:
			(selection
				initialAnalysisFor: {testClass}
				targets: targetClasses
				ignore:  failedSelectorInOriginal)
]

{ #category : #accessing }
SAResultItem >> runProfile [
	^ runProfile
]

{ #category : #accessing }
SAResultItem >> runProfile: aProfile [
	runProfile := aProfile
]

{ #category : #'as yet unclassified' }
SAResultItem >> safeFail: block key: aKey addTo: aDictionary [
	| theValue |
	theValue := block
		on: Error
		do: [ :x | 
			Stdio stdout
				nextPutAll: Time nowUTC print24;
				nextPutAll: String space;
				nextPutAll: x class asString;
				nextPutAll: ': ';
				nextPutAll: x asString;
				nextPutAll: '-';
				nextPutAll: x messageText;
				lf;
				flush.
			'N/A' ].
	aDictionary at: aKey put: theValue
]

{ #category : #export }
SAResultItem >> saveResultToFile [
	^ self saveResultToFileAs: ''
]

{ #category : #export }
SAResultItem >> saveResultToFileAs: testClassName [
	| fileName |
	fileName := testClassName , '.json'.
	(FileLocator imageDirectory / fileName) exists ifTrue: [ (FileLocator imageDirectory / fileName) delete ]. 
	(FileLocator imageDirectory / fileName) writeStream
		nextPutAll: self asFileText;
		close.
	^ fileName
]

{ #category : #reporting }
SAResultItem >> stillAliveMutants [

	^ self amplifiedAnalysis smallAmpUncovered
]

{ #category : #accessing }
SAResultItem >> targetClasses [
	^ targetClasses
]

{ #category : #accessing }
SAResultItem >> targetClasses: anObject [
	targetClasses := anObject
]

{ #category : #accessing }
SAResultItem >> testClass [
	^ testClass
]

{ #category : #accessing }
SAResultItem >> testClass: anObject [
	testClass := anObject
]

{ #category : #accessing }
SAResultItem >> testClassTimeToRunInMillis [

	^ testClassTimeToRunInMillis
]

{ #category : #accessing }
SAResultItem >> testClassTimeToRunInMillis: anObject [

	testClassTimeToRunInMillis := anObject
]

{ #category : #accessing }
SAResultItem >> timeBudgetFinished [
	^ timeBudgetFinished
]

{ #category : #accessing }
SAResultItem >> timeBudgetFinished: anObject [
	timeBudgetFinished := anObject
]

{ #category : #reporting }
SAResultItem >> totalTime [
	^ totalTime
]

{ #category : #reporting }
SAResultItem >> totalTime: aTime [
	totalTime := aTime
]

{ #category : #reporting }
SAResultItem >> totalTimeLabel [
	^ testClass name , ' (' , self totalTime humanReadablePrintString, ')'
]
