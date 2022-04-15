Class {
	#name : #SADSpotSelection,
	#superclass : #SAAbstractSelection,
	#instVars : [
		'shadowResults',
		'loggerBlock',
		'onBeforeMutant',
		'onMutationEvaluation'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SADSpotSelection class >> defaultOracleReduction [
	^ SAMuTalkFirstFailOracleReduction 
]

{ #category : #'as yet unclassified' }
SADSpotSelection class >> getNewCoveredFor: methodAST [
^ (methodAST pragmas select: [ :pr | 
		   pr selector asString
		   = SAAbstractSelection defaultInfoPragma asString ]) collect: [ 
		  :pr | pr arguments first value ]
]

{ #category : #'as yet unclassified' }
SADSpotSelection >> analysisFor: testClasses targets: targetClasses ignore: aListOfMethods [

	| analysis1 |
	analysis1 := MutationTestingAnalysis
		             testCasesFrom: testClasses
		             mutating: targetClasses
		             using: self operators
		             with:
		             (IgnoreFailingTestsMethodsEvaluationStrategy newWith:
			              aListOfMethods)
		             with: self getMutationsGenerationStrategy.
	onBeforeMutant isNotNil & onMutationEvaluation isNotNil
		ifTrue: [ analysis1 runSmallAmpSnapshot ]
		ifFalse: [ analysis1 runSmallAmp ].

	^ analysis1
]

{ #category : #accessing }
SADSpotSelection >> astHelper [
	^ SAGenericMethods new
]

{ #category : #enumerating }
SADSpotSelection >> chooseBestFrom: theList [
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
SADSpotSelection >> chooseBestFrom: theList notIncludedIn: result [
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
SADSpotSelection >> cleanUp: generatedClass [
	self astHelper removeClass: generatedClass source: self class name.
]

{ #category : #enumerating }
SADSpotSelection >> finalizeShadowSelections [
	|result|
	result := self addInfoToSelectedMethods: shadowResults.
	^ result reject: #isNil
]

{ #category : #enumerating }
SADSpotSelection >> getMutantFromUncovereds: aMutantIndex [
	^ {(uncovered at: aMutantIndex)}
]

{ #category : #'as yet unclassified' }
SADSpotSelection >> getMutationsGenerationStrategy [

	| g |
	g := SmallAmpMutationsGenerationStrategy new.
	(onBeforeMutant isNotNil & onMutationEvaluation isNotNil) ifTrue: [ 
		g
			onBeforeMutant: onBeforeMutant;
			onMutationEvaluation: onMutationEvaluation ].
	^ g
]

{ #category : #cleanup }
SADSpotSelection >> infoPragmaFrom: aCovered [
	^ aCovered smallAmpInfoText
]

{ #category : #'as yet unclassified' }
SADSpotSelection >> initialAnalysisFor: testClasses targets: targetClasses ignore: aListOfMethods [
	| analysis1 |
	analysis1 := self analysisFor: testClasses targets: targetClasses ignore: aListOfMethods.
	uncovered := analysis1 generalResult aliveMutants.
	^ analysis1
]

{ #category : #enumerating }
SADSpotSelection >> logTestStart: aTestCaseStarted [
	(FileLocator imageDirectory / '_mutalk_lasttest.txt') writeStream
		truncate;
		nextPutAll: aTestCaseStarted testSelector;
		close
]

{ #category : #enumerating }
SADSpotSelection >> loggerBlock [
	^ loggerBlock
		ifNil:
			[ loggerBlock := [ :aTestCaseStarted | self logTestStart: aTestCaseStarted ] ]
]

{ #category : #enumerating }
SADSpotSelection >> loggerSubscribe: testClasses [
	testClasses do: [ :cls |  
	cls announcer
		when: TestCaseStarted
		do: self loggerBlock ]
]

{ #category : #enumerating }
SADSpotSelection >> loggerUnsubscribe: testClasses [
	testClasses do: [ :cls | cls announcer unsubscribe: self loggerBlock ]
]

{ #category : #'private-debugging' }
SADSpotSelection >> matrixFromMutalk: aResult [
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
SADSpotSelection >> mutalkRun: aPopulation [

	| testClasses testClass targetClasses tempTestClass |
	testClass := aPopulation atRandom testClass.
	targetClasses := aPopulation atRandom testTargets.
	tempTestClass :=  (self astHelper
		                buildTestClassWith:
		                (aPopulation collect: [ :tcase | tcase testMethod ])
		                using: testClass).
	testClasses := OrderedCollection with: tempTestClass.
	tempTestClass smallAmpOriginalTestCase = tempTestClass ifFalse: [ 
		testClasses add: tempTestClass smallAmpOriginalTestCase ].
	^ self mutalkRunClass: testClasses targetClasses: targetClasses
]

{ #category : #'as yet unclassified' }
SADSpotSelection >> mutalkRunClass: testClasses targetClasses: targetClasses [

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
SADSpotSelection >> mutalkRunSnapshot: aPopulation [

	| testClasses testClass targetClasses tempTestClass |
	testClass := aPopulation atRandom testClass.
	targetClasses := aPopulation atRandom testTargets.
	tempTestClass := (self astHelper
		                buildTestClassWith:
		                (aPopulation collect: [ :tcase | tcase testMethod ])
		                using: testClass).
	testClasses := OrderedCollection with: tempTestClass .
	tempTestClass smallAmpOriginalTestCase = tempTestClass ifFalse: [ 
		testClasses add: tempTestClass smallAmpOriginalTestCase ].
	^ self
		  mutalkRunSnapshotClass: testClasses
		  targetClasses: targetClasses
]

{ #category : #'as yet unclassified' }
SADSpotSelection >> mutalkRunSnapshotClass: testClasses targetClasses: targetClasses [

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
SADSpotSelection >> onBeforeMutant [
	^ onBeforeMutant
]

{ #category : #accessing }
SADSpotSelection >> onBeforeMutant: anObject [
	onBeforeMutant := anObject
]

{ #category : #accessing }
SADSpotSelection >> onMutationEvaluation [
	^ onMutationEvaluation
]

{ #category : #accessing }
SADSpotSelection >> onMutationEvaluation: anObject [
	onMutationEvaluation := anObject
]

{ #category : #'as yet unclassified' }
SADSpotSelection >> operators [

	config mutalkUseOriginalOperators
		ifNil: [ ^ MutantOperator contentsAllStopRecursions ]
		ifNotNil: [ ^ MutantOperator contents ]
]

{ #category : #enumerating }
SADSpotSelection >> select: aPopulation [
	| analysisResult alives result newKills |
	result := Dictionary new.
	analysisResult := self mutalkRun: aPopulation.
	alives := analysisResult generalResult aliveMutants.
	newKills := 
	uncovered
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
	result := self addInfoToSelectedMethods: result.
	^ result reject: #isNil
]

{ #category : #enumerating }
SADSpotSelection >> select: aPopulation forMutantAtIndex: aMutantIndex [

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
SADSpotSelection >> select: aPopulation forMutantEvaluation: aMutantEvaluation [

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
SADSpotSelection >> selectSnapshot: aPopulation [
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
SADSpotSelection >> setUpShadowSelections [
	shadowResults := Dictionary new.
]
