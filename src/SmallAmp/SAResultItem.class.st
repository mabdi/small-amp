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
		'runProfile'
	],
	#category : #'SmallAmp-Model'
}

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
SAResultItem >> amplifiedMutationScore [
	^ amplifiedAnalysis generalResult mutationScore
]

{ #category : #reporting }
SAResultItem >> asDictionaryObject [
	^ {(#testCase -> testClass name).
	(#targetClasses -> (targetClasses collect: #name) asArray).
	(#amplifiedClass -> self amplifiedClass name).
	(#amplifiedMethods -> (self amplifiedMethods collect: #name) asArray).
	(#mutationScoreBefore -> self originalMutationScore).
	(#mutationScoreAfter -> self amplifiedMutationScore).
	(#timeTotal -> self totalTime asSeconds).
	(#targetLoc -> (targetClasses collect: #linesOfCode) sum).
	(#testLoc -> testClass linesOfCode).
	(#testAmpLoc -> (self amplifiedMethods collect: #linesOfCode) sum).
	(#timeDetail -> self detailedTimeLabel asArray).
	(#methodsNotProfiled
		-> (self methodsNotProfiled collect: #name) asArray).
	(#testMethodsIgnored
		-> (self failedSelectorInOriginal collect: #name) asArray).
	(#numberOfAllMutationsInOriginal -> self numberOfAllMutationsInOriginal size).
	(#mutantsAliveInOriginal
		->
			(self aliveMutantsInOriginal
				collect: [ :m | m mutant asDictionaryObject ]) asArray).
	(#killedInAmplified
		->
			(self killedMutantsInAmplified
				collect: [ :m | m mutant asDictionaryObject ]) asArray).
	(#stillAliveMutants
		->
			(self stillAliveMutants collect: [ :m | m mutant asDictionaryObject ])
				asArray)} asDictionary
]

{ #category : #export }
SAResultItem >> asFileText [
	^ STONJSON toStringPretty: self asDictionaryObject 
]

{ #category : #reporting }
SAResultItem >> detailedTimeLabel [
	| sum |
	sum := (self logs summary collect: #value) sum.
	^ self logs summary
				collect: [ :s | 
					
							s key asString , ': % '
								, (100 * s value / sum printShowingDecimalPlaces: 2) , ' ('
								, (Duration milliSeconds: s value) humanReadablePrintString
								, ')']
						
]

{ #category : #accessing }
SAResultItem >> failedSelectorInOriginal [
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
	keys := self runProfile profile keys
		select:
			[ :p | self targetClasses anySatisfy: [ :t | p beginsWith: '#' , t name ] ].
	^ (self targetClasses
						flatCollect: [ :c | 
							(c methods select: [ :m | m selector includesSubstring: ':' ])
								reject: [ :m | 
									keys
										anySatisfy: [ :k | k beginsWith: '#' , c name , '#' , m selector ] ] ])
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
	^ self testClass methods
]

{ #category : #reporting }
SAResultItem >> originalMutationScore [
	^ originalAnalysis generalResult mutationScore
]

{ #category : #accessing }
SAResultItem >> runProfile [
	^ runProfile
]

{ #category : #accessing }
SAResultItem >> runProfile: aProfile [
	runProfile := aProfile
]

{ #category : #export }
SAResultItem >> saveResultToFile [
	^ self saveResultToFileAs: ''
]

{ #category : #export }
SAResultItem >> saveResultToFileAs: testClassName [
	| fileName |
	fileName := testClassName, UUID new asString36 , '.txt'.
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
	sum := (self logs summary collect: #value) sum.
	^ (Duration milliSeconds: sum) 
]

{ #category : #reporting }
SAResultItem >> totalTimeLabel [
	^ testClass name , ' (' , self totalTime humanReadablePrintString, ')'
]
