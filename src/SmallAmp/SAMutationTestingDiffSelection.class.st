Class {
	#name : #SAMutationTestingDiffSelection,
	#superclass : #SAAbstractSelection,
	#instVars : [
		'shadowResults',
		'loggerBlock',
		'onBeforeMutant',
		'onMutationEvaluation',
		'assertionsFailed'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SAMutationTestingDiffSelection class >> defaultOracleReduction [
	^ SAMuTalkFirstFailOracleReduction 
]

{ #category : #'as yet unclassified' }
SAMutationTestingDiffSelection >> analysisFor: testClasses targets: targetClasses ignore: aListOfMethods [

	| analysis1 |
	analysis1 := MutationTestingAnalysis
		             testCasesFrom: testClasses
		             mutating: targetClasses
		             using: self operators 
		             with:
		             (IgnoreFailingTestsMethodsEvaluationStrategy newWith:
			              aListOfMethods)
		             with: SmallAmpMutationsGenerationStrategy new.
	analysis1 runSmallAmp.
	^ analysis1
]

{ #category : #asserting }
SAMutationTestingDiffSelection >> assertObjectState: anObject selector: selector cache: modelsCache varName: aVariableName id: id type: type serializationMaxDepth: serializationMaxDepth [
	| history item diff |
	history := (modelsCache at: selector)
		detect: [ :x | x id = id and: [ x observedBy = type ] ].
	item := anObject
		smallAmpAcceptSerializerVisitor: (SAStateSerializer withDepth: serializationMaxDepth)
		atDepth: 0.
	item
		name: aVariableName;
		id: id.
	diff := history diff: item.
	diff
		ifNotNil: [ assertionsFailed
				at:
					(':'
						join:
							{selector asString.
							id asString.
							type asString})
				put: diff.
				^ false ]
		ifNil: [ ^ true ]
]

{ #category : #accessing }
SAMutationTestingDiffSelection >> astHelper [
	^ SAGenericMethods new
]

{ #category : #'as yet unclassified' }
SAMutationTestingDiffSelection >> buildAssertionsFrom: failedDiff insteadOf: node observed: observed [
	| asserts |
	observed theValue: failedDiff.
	asserts := observed buildAssertions: SAAssertGenerator new.
	node parent replaceNode: node withNodes: asserts.
	
]

{ #category : #enumerating }
SAMutationTestingDiffSelection >> chooseBestFrom: theList [
	"first select shortest methods
	Then, select minimum change,"

	| shortestLen shorts |
	theList ifEmpty: [ ^ nil ].
	shortestLen := (theList collect: [ :s | s testMethod lines size ]) min.
	shorts := theList
		select: [ :s | s testMethod lines size = shortestLen ].
	^ (shorts
		sort: [ :a :b | 
			(a selector count: [ :x | x = $_ ])
				< (b selector count: [ :x | x = $_ ]) ]) first
]

{ #category : #enumerating }
SAMutationTestingDiffSelection >> chooseBestFrom: theList notIncludedIn: result [
	"first select shortest methods
	Then, select minimum change,"

	| shortestLen shorts aList |
	aList := theList
		reject: [ :s | result anySatisfy: [ :s2 | s2 testMethod = s testMethod ] ].
	aList ifEmpty: [ ^ nil ].
	shortestLen := (aList collect: [ :s | s testMethod lines size ]) min.
	shorts := aList
		select: [ :s | s testMethod lines size = shortestLen ].
	^ (shorts
		sort: [ :a :b | 
			(a selector count: [ :x | x = $_ ])
				< (b selector count: [ :x | x = $_ ]) ]) first
]

{ #category : #cleanup }
SAMutationTestingDiffSelection >> cleanUp: generatedClass [
	self astHelper removeClass: generatedClass source: self class name.
]

{ #category : #enumerating }
SAMutationTestingDiffSelection >> finalizeShadowSelections [
	|result|
	result := self addInfoToSelectedMethods: shadowResults.
	^ result reject: #isNil
]

{ #category : #'as yet unclassified' }
SAMutationTestingDiffSelection >> generateAssertions: testModel [
	| ast asserts |
	ast := RBParser parseMethod: testModel testMethod.
	asserts := (ast statements select: #isMessage)
		select: [ :node | node selector = #assertObjectState:varName:id:type: ].
	asserts
		do: [ :node | 
			| id observed observedBy |
			id := (node arguments at: 3) value.
			observedBy := (node arguments at: 4) value.
			assertionsFailed
				at:
					(':'
						join:
							{testModel selector.
							id asString.
							observedBy asString})
				ifPresent: [ :faildKeys | 
					observed := testModel observedState
						detect: [ :x | x id = id and: [ x observedBy = observedBy ] ].
					self
						buildAssertionsFrom: faildKeys
						insteadOf: node
						observed: observed ]
				ifAbsent: [ node parent removeNode: node ] ].
		testModel testMethod: ast formattedCode.
		^ testModel 
]

{ #category : #enumerating }
SAMutationTestingDiffSelection >> getMutantFromUncovereds: aMutantIndex [
	^ {(uncovered at: aMutantIndex)}
]

{ #category : #cleanup }
SAMutationTestingDiffSelection >> infoPragmaFrom: aCovered [
	^ aCovered smallAmpInfoText
]

{ #category : #'as yet unclassified' }
SAMutationTestingDiffSelection >> initialAnalysisFor: testClasses targets: targetClasses ignore: aListOfMethods [
	| analysis1 |
	analysis1 := self analysisFor: testClasses targets: targetClasses ignore: aListOfMethods.
	uncovered := analysis1 generalResult aliveMutants.
	^ analysis1
]

{ #category : #enumerating }
SAMutationTestingDiffSelection >> logTestStart: aTestCaseStarted [
	(FileLocator imageDirectory / '_mutalk_lasttest.txt') writeStream
		truncate;
		nextPutAll: aTestCaseStarted testSelector;
		close
]

{ #category : #enumerating }
SAMutationTestingDiffSelection >> loggerBlock [
	^ loggerBlock
		ifNil:
			[ loggerBlock := [ :aTestCaseStarted | self logTestStart: aTestCaseStarted ] ]
]

{ #category : #enumerating }
SAMutationTestingDiffSelection >> loggerSubscribe: testClasses [
	testClasses do: [ :cls |  
	cls announcer
		when: TestCaseStarted
		do: self loggerBlock ]
]

{ #category : #enumerating }
SAMutationTestingDiffSelection >> loggerUnsubscribe: testClasses [
	testClasses do: [ :cls | cls announcer unsubscribe: self loggerBlock ]
]

{ #category : #'private-debugging' }
SAMutationTestingDiffSelection >> matrixFromMutalk: aResult [
	| matrix instance selectors muts |
	muts := OrderedCollection new.
	selectors := OrderedCollection new.
	muts := aResult particularResults
		collect: [ :mut | mut mutant modifiedSource ].
	instance := aResult particularResults atRandom result.
	selectors
		addAll: (instance passed collect: [ :x | x selector ]);
		addAll: (instance failures collect: [ :x | x selector ]);
		addAll: (instance errors collect: [ :x | x selector ]);
		addAll: (instance skipped collect: [ :x | x selector ]);
		sort.
	matrix := Array2D rows: muts size columns: selectors size.
	aResult particularResults
		doWithIndex: [ :mut :idx | 
			mut result passed
				do: [ :x | matrix at: idx at: (selectors indexOf: x selector) put: $p ].
			mut result failures
				do: [ :x | matrix at: idx at: (selectors indexOf: x selector) put: $f ].
			mut result errors
				do: [ :x | matrix at: idx at: (selectors indexOf: x selector) put: $e ].
			mut result skipped
				do: [ :x | matrix at: idx at: (selectors indexOf: x selector) put: $s ] ].
	Transcript tab.
	selectors
		do: [ :s | 
			Transcript
				show: s;
				tab ].
	Transcript cr.
	muts
		withIndexDo: [ :x :idx | 
			Transcript
				show: idx;
				tab.
			1 to: matrix columnCount do: [ :c | 
				Transcript
					show: (((matrix at: idx at: c) = $f) ifTrue: [1] ifFalse:[0]);
					tab ].
			Transcript cr ].
	self halt
]

{ #category : #'as yet unclassified' }
SAMutationTestingDiffSelection >> mutalkRun: aPopulation [
	| testClasses testClass targetClasses generatedClass |
	testClass := aPopulation atRandom testClass.
	targetClasses := aPopulation atRandom testTargets.
	generatedClass := self astHelper
		buildTestClassWithModels: aPopulation
		using: testClass
		config: config.
	generatedClass assertHandler: self.
	assertionsFailed := Dictionary new.
	testClasses := {generatedClass}.
	^ self mutalkRunClass: testClasses targetClasses: targetClasses
]

{ #category : #'as yet unclassified' }
SAMutationTestingDiffSelection >> mutalkRunClass: testClasses targetClasses: targetClasses [

	| analysis1 result |
	self loggerSubscribe: testClasses.
	self astHelper disableDeprecationsWhile: [ 
		analysis1 := MutationTestingAnalysis
			             testCasesFrom: testClasses
			             mutating: targetClasses
			             using: self operators 
			             with:
			             AllTestsMethodsRunningMutantEvaluationStrategy new
			             with:
				             (SmallAmpMutationsGenerationStrategy new mutants:
					              (uncovered collect: #mutant)).
		result := analysis1 runSmallAmpVerbose.
		config debug ifTrue: [ result ifFalse: [ self halt ] ] ].
	self loggerUnsubscribe: testClasses.
	testClasses do: [ :newTestClass | self cleanUp: newTestClass ].
	^ analysis1
]

{ #category : #'as yet unclassified' }
SAMutationTestingDiffSelection >> mutalkRunSnapshot: aPopulation [
	| testClasses testClass targetClasses generatedClass |
	testClass := aPopulation atRandom testClass.
	targetClasses := aPopulation atRandom testTargets.
	generatedClass := self astHelper
		buildTestClassWithModels: aPopulation
		using: testClass
		config: config.
	generatedClass assertHandler: self.
	assertionsFailed := Dictionary new.
	testClasses := {generatedClass}.
	^ self
		mutalkRunSnapshotClass: testClasses
		targetClasses: targetClasses
]

{ #category : #'as yet unclassified' }
SAMutationTestingDiffSelection >> mutalkRunSnapshotClass: testClasses targetClasses: targetClasses [

	| analysis1 result |
	self loggerSubscribe: testClasses.
	self astHelper disableDeprecationsWhile: [ 
		analysis1 := MutationTestingAnalysis
			             testCasesFrom: testClasses
			             mutating: targetClasses
			             using: self operators 
			             with:
			             AllTestsMethodsRunningMutantEvaluationStrategy new
			             with: (SmallAmpMutationsGenerationStrategy new
					              onBeforeMutant: onBeforeMutant;
					              onMutationEvaluation: onMutationEvaluation;
					              mutants: (uncovered collect: #mutant)).
		result := analysis1 runSmallAmpSnapshot.
		config debug ifTrue: [ result ifFalse: [ self halt ] ] ].
	self loggerUnsubscribe: testClasses.
	testClasses do: [ :newTestClass | self cleanUp: newTestClass ].
	^ analysis1
]

{ #category : #accessing }
SAMutationTestingDiffSelection >> onBeforeMutant [
	^ onBeforeMutant
]

{ #category : #accessing }
SAMutationTestingDiffSelection >> onBeforeMutant: anObject [
	onBeforeMutant := anObject
]

{ #category : #accessing }
SAMutationTestingDiffSelection >> onMutationEvaluation [
	^ onMutationEvaluation
]

{ #category : #accessing }
SAMutationTestingDiffSelection >> onMutationEvaluation: anObject [
	onMutationEvaluation := anObject
]

{ #category : #accesing }
SAMutationTestingDiffSelection >> operators [

	config mutalkUseOriginalOperators
		ifNil: [ ^ MutantOperator contentsAll ]
		ifNotNil: [ ^ MutantOperator contents ]
]

{ #category : #enumerating }
SAMutationTestingDiffSelection >> select: aPopulation [
	| analysisResult alives result newKills |
	result := Dictionary new.
	analysisResult := self mutalkRun: aPopulation.
	alives := analysisResult generalResult aliveMutants.
	newKills := uncovered
		reject: [ :s | 
			alives
				anySatisfy: [ :z | z mutant modifiedSource = s mutant modifiedSource ] ].
	uncovered := uncovered
		select: [ :s | 
			alives
				anySatisfy: [ :z | z mutant modifiedSource = s mutant modifiedSource ] ].
	analysisResult particularResults
		do: [ :item | 
			newKills
				detect: [ :s | s mutant modifiedSource = item mutant modifiedSource ]
				ifFound: [ :s | 
					item result
						ifNotNil: [ item result failures
								ifNotEmpty: [ | sels selected |
									sels := item result failures collect: #selector.
									selected := self
										chooseBestFrom: (aPopulation select: [ :p | sels includes: p selector ])
										notIncludedIn: result.
									selected ifNotNil: [ result at: item put: selected ] ] ] ] ].
	result do: [:testModel | self generateAssertions: testModel ].
	result := self addInfoToSelectedMethods: result.
	^ result reject: #isNil
]

{ #category : #enumerating }
SAMutationTestingDiffSelection >> select: aPopulation forMutantAtIndex: aMutantIndex [

	| analysisResult alives result newKills testClasses testClass targetClasses |
	aPopulation ifEmpty: [ ^ {  } ].
	result := Dictionary new.
	testClass := aPopulation atRandom testClass.
	targetClasses := aPopulation atRandom testTargets.
	testClasses := { (self astHelper
		                buildTestClassWith:
		                (aPopulation collect: [ :tcase | tcase testMethod ])
		                using: testClass) }.
	self loggerSubscribe: testClasses.
	self astHelper disableDeprecationsWhile: [ 
		analysisResult := MutationTestingAnalysis
			                  testCasesFrom: testClasses
			                  mutating: targetClasses
			                  using: self operators 
			                  with:
			                  AllTestsMethodsRunningMutantEvaluationStrategy
				                  new
			                  with:
				                  (SmallAmpMutationsGenerationStrategy new 
					                   mutants:
					                   ((self getMutantFromUncovereds: aMutantIndex) 
						                    collect: #mutant)).
		analysisResult runSmallAmpVerbose ].
	self loggerUnsubscribe: testClasses.
	testClasses do: [ :newTestClass | self cleanUp: newTestClass ].
	alives := analysisResult generalResult aliveMutants.
	alives ifNotEmpty: [ :x | ^ {  } ] ifEmpty: [ 
		newKills := self getMutantFromUncovereds: aMutantIndex.
		uncovered := uncovered reject: [ :s | 
			             newKills first mutant modifiedSource
			             = s mutant modifiedSource ] ].
	analysisResult particularResults do: [ :item | 
		newKills
			detect: [ :s | 
			s mutant modifiedSource = item mutant modifiedSource ]
			ifFound: [ :s | 
				item result ifNotNil: [ 
					item result failures ifNotEmpty: [ 
						| sels selected |
						sels := item result failures collect: #selector.
						selected := self
							            chooseBestFrom:
							            (aPopulation select: [ :p | 
								             sels includes: p selector ])
							            notIncludedIn: result.
						selected ifNotNil: [ result at: item put: selected ] ] ] ] ].
	shadowResults addAll: result
]

{ #category : #enumerating }
SAMutationTestingDiffSelection >> select: aPopulation forMutantEvaluation: aMutantEvaluation [

	| analysisResult alives result newKills testClasses testClass targetClasses |
	aPopulation ifEmpty: [ ^ {  } ].
	result := Dictionary new.
	testClass := aPopulation atRandom testClass.
	targetClasses := aPopulation atRandom testTargets.
	testClasses := { (self astHelper
		                buildTestClassWith:
		                (aPopulation collect: [ :tcase | tcase testMethod ])
		                using: testClass) }.
	self loggerSubscribe: testClasses.
	self astHelper disableDeprecationsWhile: [ 
		analysisResult := MutationTestingAnalysis
			                  testCasesFrom: testClasses
			                  mutating: targetClasses
			                  using: self operators 
			                  with:
			                  AllTestsMethodsRunningMutantEvaluationStrategy
				                  new
			                  with:
				                  (SmallAmpMutationsGenerationStrategy new 
					                   mutants: { aMutantEvaluation mutant }).
		analysisResult runSmallAmpVerbose ].
	self loggerUnsubscribe: testClasses.
	testClasses do: [ :newTestClass | self cleanUp: newTestClass ].
	alives := analysisResult generalResult aliveMutants.
	alives ifNotEmpty: [ :x | ^ {  } ] ifEmpty: [ 
		newKills := { aMutantEvaluation }.
		uncovered := uncovered reject: [ :s | 
			             newKills first mutant modifiedSource
			             = s mutant modifiedSource ] ].
	analysisResult particularResults do: [ :item | 
		newKills
			detect: [ :s | 
			s mutant modifiedSource = item mutant modifiedSource ]
			ifFound: [ :s | 
				item result ifNotNil: [ 
					item result failures ifNotEmpty: [ 
						| sels selected |
						sels := item result failures collect: #selector.
						selected := self
							            chooseBestFrom:
							            (aPopulation select: [ :p | 
								             sels includes: p selector ])
							            notIncludedIn: result.
						selected ifNotNil: [ result at: item put: selected ] ] ] ] ].
	shadowResults addAll: result
]

{ #category : #enumerating }
SAMutationTestingDiffSelection >> selectSnapshot: aPopulation [
	| analysisResult alives result newKills |
	result := Dictionary new.
	analysisResult := self mutalkRunSnapshot: aPopulation.
	alives := analysisResult generalResult aliveMutants.
	newKills := uncovered
		reject: [ :s | 
			alives
				anySatisfy: [ :z | z mutant modifiedSource = s mutant modifiedSource ] ].
	uncovered := uncovered
		select: [ :s | 
			alives
				anySatisfy: [ :z | z mutant modifiedSource = s mutant modifiedSource ] ].
	analysisResult particularResults
		do: [ :item | 
			newKills
				detect: [ :s | s mutant modifiedSource = item mutant modifiedSource ]
				ifFound: [ :s | 
					item result
						ifNotNil: [ item result failures
								ifNotEmpty: [ | sels selected |
									sels := item result failures collect: #selector.
									selected := self
										chooseBestFrom: (aPopulation select: [ :p | sels includes: p selector ])
										.
									selected ifNotNil: [ result at: item put: selected ] ] ] ] ].
	result := self addInfoToSelectedMethods: result.
	^ result reject: #isNil
]

{ #category : #enumerating }
SAMutationTestingDiffSelection >> setUpShadowSelections [
	shadowResults := Dictionary new.
]
