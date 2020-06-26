Class {
	#name : #SAResultItem,
	#superclass : #Object,
	#instVars : [
		'failedSelectorInOriginal',
		'amplifiedClass',
		'amplifiedAnalysis',
		'targetClasses',
		'testClass',
		'originalAnalysis',
		'logs',
		'runProfile',
		'amplifiedCoverage',
		'originalCoverage'
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

{ #category : #reporting }
SAResultItem >> aliveMutantsInOriginal [
^ self originalAnalysis generalResult aliveMutants
]

{ #category : #accessing }
SAResultItem >> amplifiedAnalysis [
	^ amplifiedAnalysis
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

{ #category : #reporting }
SAResultItem >> amplifiedMethods [
	^ self amplifiedClass methods
		select: [ :z | z hasPragmaNamed: SAASTHelper new defaultPragma ]
]

{ #category : #reporting }
SAResultItem >> amplifiedMethodsAssertionDensity [
	self amplifiedMethods ifEmpty: [ ^ 0 ].
	^ ((self amplifiedMethods
		collect: [ :m | SATestAssertionDensity new densityForMethod: m ])
		inject: 0
		into: [ :s :i | s + i ]) / self amplifiedMethods size
		printShowingDecimalPlaces: 2
]

{ #category : #reporting }
SAResultItem >> amplifiedMutationScore [
	^ amplifiedAnalysis generalResult mutationScore
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
	self safeFail: [ testClass name ] key: #testCase addTo: result.
	self
		safeFail: [ (targetClasses collect: #name) asArray ]
		key: #targetClasses
		addTo: result.
	self
		safeFail: [ self amplifiedClass name ]
		key: #amplifiedClass
		addTo: result.
	self
		safeFail: [ (self amplifiedMethods collect: #name) asArray ]
		key: #amplifiedMethods
		addTo: result.
	self
		safeFail: [ self originalMutationScore ]
		key: #mutationScoreBefore
		addTo: result.
	self
		safeFail: [ self amplifiedMutationScore ]
		key: #mutationScoreAfter
		addTo: result.
	"self
		safeFail: [ self directTestingOriginal printShowingDecimalPlaces: 2 ]
		key: #directTestingOriginal
		addTo: result."
	self
		safeFail: [ self totalTime asSeconds ]
		key: #timeTotal
		addTo: result.
	self
		safeFail:
			[ (targetClasses collect: [ :c | c linesOfCode + c class linesOfCode ])
				inject: 0
				into: [ :accum :each | accum + each ] ]
		key: #targetLoc
		addTo: result.
	"self
		safeFail: [ ((targetClasses
				collect: [ :cls | (self codeChurnForClass: cls) asNumber ])
				inject: 0
				into: [ :accum :each | accum + each ])
				printShowingDecimalPlaces: 2 ]
		key: #targetChurn
		addTo: result.
	self
		safeFail: [ (self codeChurnForClass: testClass) printShowingDecimalPlaces: 2 ]
		key: #testChurn
		addTo: result."
	self
		safeFail: [ testClass linesOfCode asString ]
		key: #testLoc
		addTo: result.
	"self
		safeFail: [ self amplifiedTestCoverage methodsCoverage ]
		key: #amplifiedCoverageMethods
		addTo: result.
	self
		safeFail: [ self amplifiedTestCoverage branchesCoverage ]
		key: #amplifiedCoverageBranches
		addTo: result.
	self
		safeFail: [ self amplifiedTestCoverage statementsCoverage ]
		key: #amplifiedCoverageStatementes
		addTo: result.
	self
		safeFail: [ self originalTestCoverage methodsCoverage ]
		key: #originalCoverageMethods
		addTo: result.
	self
		safeFail: [ self originalTestCoverage branchesCoverage ]
		key: #originalCoverageBranches
		addTo: result.
	self
		safeFail: [ self originalTestCoverage statementsCoverage ]
		key: #originalCoverageStatementes
		addTo: result."
	self
		safeFail: [ (self amplifiedMethods collect: #linesOfCode)
				inject: 0
				into: [ :accum :each | accum + each ] ]
		key: #testAmpLoc
		addTo: result.
	self
		safeFail: [ self detailedTimeLabel asArray ]
		key: #timeDetail
		addTo: result.
	self
		safeFail: [ (self methodsNotProfiled collect: #name) asArray ]
		key: #methodsNotProfiled
		addTo: result.
	"self
		safeFail: [ self originalMethodsAssertionDensity ]
		key: #assertionDensityOriginal
		addTo: result.
	self
		safeFail: [ self amplifiedMethodsAssertionDensity ]
		key: #assertionDensityAmplified
		addTo: result."
	self
		safeFail: [ (self failedSelectorInOriginal collect: #name) asArray ]
		key: #testMethodsIgnored
		addTo: result.
	self
		safeFail: [ self numberOfAllMutationsInOriginal ]
		key: #numberOfAllMutationsInOriginal
		addTo: result.
	self
		safeFail: [ (self aliveMutantsInOriginal
				collect: [ :m | m mutant asDictionaryObject ]) asArray ]
		key: #mutantsAliveInOriginal
		addTo: result.
	self
		safeFail: [ (self killedMutantsInAmplified
				collect: [ :m | m mutant asDictionaryObject ]) asArray ]
		key: #killedInAmplified
		addTo: result.
	self
		safeFail: [ (self stillAliveMutants
				collect: [ :m | m mutant asDictionaryObject ]) asArray ]
		key: #stillAliveMutants
		addTo: result.
	^ result
]

{ #category : #export }
SAResultItem >> asFileText [
	^ STONJSON toStringPretty: self asDictionaryObject 
]

{ #category : #reporting }
SAResultItem >> detailedTimeLabel [
	| sum |
	self logs summary ifEmpty: [ ^ {} ].
	sum := (self logs summary collect: #value) sum.
	^ self logs summary
		collect: [ :s | 
			s key asString , ': % '
				, (100 * s value / sum printShowingDecimalPlaces: 2) , ' ('
				, (Duration milliSeconds: s value) humanReadablePrintString , ')' ]
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
	| result |
	failedSelectorInOriginal
		ifNil: [ result := testClass suite run.
			failedSelectorInOriginal:=
			(result failures , result expectedDefects
				collect: [ :failed | failed class lookupSelector: failed selector ])
				asOrderedCollection. ].
	^ failedSelectorInOriginal
]

{ #category : #accessing }
SAResultItem >> failedSelectorInOriginal: aListOfFaileds [
	failedSelectorInOriginal := aListOfFaileds 
]

{ #category : #private }
SAResultItem >> filterJustAddedMethods: newClass basedOn: originalClass [
	^ newClass methods
		reject: [ :m | originalClass selectors includes: m selector ]
]

{ #category : #private }
SAResultItem >> filterJustKilledMutants: newKilledMutants basedOn: originalKilledMutants [
	^ newKilledMutants
		reject: [ :m | 
			(originalKilledMutants collect: [ :x | x mutant modifiedSource ])
				includes: m mutant modifiedSource ]
]

{ #category : #initialization }
SAResultItem >> initialize [ 
	logs := SALogger new
]

{ #category : #reporting }
SAResultItem >> killedMutantsInAmplified [
	^ self
		filterJustKilledMutants: self amplifiedAnalysis  generalResult killedMutants
		basedOn: self originalAnalysis generalResult killedMutants
]

{ #category : #accessing }
SAResultItem >> logs [
	^ logs
]

{ #category : #reporting }
SAResultItem >> markDownOn: stream [
	stream
		nextPutAll: '|';
		nextPutAll: testClass name;
		nextPutAll: '|';
		nextPutAll: (', ' join: (targetClasses collect: #name));
		nextPutAll: '|';
		nextPutAll:
			(Duration
				seconds: ((self logs summary collect: #value) sum / 1000) asInteger)
				humanReadablePrintString;
		nextPutAll: '|'.
	self markDownOn: stream class: testClass analysis: originalAnalysis.
	stream nextPutAll: '|'.
	self markDownOn: stream class: amplifiedClass analysis: amplifiedAnalysis.
	
	stream nextPutAll: '|'
]

{ #category : #private }
SAResultItem >> markDownOn: stream class: theClass analysis: analysis [
	stream nextPutAll: '#TestMethods: '.
	stream nextPutAll: theClass methods size asString.
	stream nextPutAll: '<br>'.
	stream nextPutAll: '#AllMutations: '.
	stream
		nextPutAll: analysis generalResult numberOfEvaluatedMutants asString.
	stream nextPutAll: '<br>'.
	stream nextPutAll: '#KilledMutants: '.
	stream
		nextPutAll:
			analysis generalResult numberOfKilledOrTerminatedMutants
				asString.
	stream nextPutAll: '<br>'.
	stream nextPutAll: 'Score: %'.
	stream
		nextPutAll: analysis generalResult mutationScore asString.
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

{ #category : #evaluation }
SAResultItem >> mutalkRunMutated [
	| analysis1 |
	analysis1 := MutationTestingAnalysis
		testCasesFrom: {amplifiedClass}
		mutating: targetClasses
		using: MutantOperator contents
		with:
			(IgnoreFailingTestsMethodsEvaluationStrategy
				newWith: self failedSelectorInOriginal)
		with: SmallAmpMutationsGenerationStrategy new.
	analysis1 runSmallAmp.
	amplifiedAnalysis := analysis1
]

{ #category : #evaluation }
SAResultItem >> mutalkRunOriginal [
	| analysis1 |
	analysis1 := MutationTestingAnalysis
		testCasesFrom: {testClass}
		mutating: targetClasses
		using: MutantOperator contents
		with:
			(IgnoreFailingTestsMethodsEvaluationStrategy
				newWith: self failedSelectorInOriginal)
		with: (SmallAmpMutationsGenerationStrategy new).
	analysis1 runSmallAmp.
	originalAnalysis := analysis1
]

{ #category : #reporting }
SAResultItem >> numberOfAllMutationsInOriginal [
	^ self originalAnalysis generalResult numberOfEvaluatedMutants
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
	^ (((self originalMethods
		collect: [ :m | SATestAssertionDensity new densityForMethod: m ])
		inject: 0
		into: [ :s :i | s + i ]) / self originalMethods size) printShowingDecimalPlaces: 2
]

{ #category : #reporting }
SAResultItem >> originalMutationScore [
	^ originalAnalysis generalResult mutationScore
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
SAResultItem >> regenerate [
	self
		mutalkRunOriginal;
		mutalkRunMutated;
		failedSelectorInOriginal
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
	^ amplifiedAnalysis generalResult aliveMutants
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

{ #category : #reporting }
SAResultItem >> totalTime [
	| sum |
	self logs summary ifEmpty: [ ^ Duration milliSeconds: 0 ].
	sum := (self logs summary collect: #value) sum.
	^ Duration milliSeconds: sum
]

{ #category : #reporting }
SAResultItem >> totalTimeLabel [
	^ testClass name , ' (' , self totalTime humanReadablePrintString, ')'
]
