Class {
	#name : #SAMutationCoverageDSpotSelection,
	#superclass : #SAAbstractSelection,
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SAMutationCoverageDSpotSelection class >> defaultOracleReduction [
	^ SAMuTalkFirstFailOracleReduction 
]

{ #category : #'as yet unclassified' }
SAMutationCoverageDSpotSelection >> analysisFor: testClasses targets: targetClasses ignore: aListOfMethods [
	| analysis1 |
	analysis1 := MutationTestingAnalysis
		testCasesFrom: testClasses
		mutating: targetClasses
		using: MutantOperator contents
		with:
			(IgnoreFailingTestsMethodsEvaluationStrategy
				newWith: aListOfMethods)
		with: SmallAmpMutationsGenerationStrategy new.
	analysis1 runSmallAmp.
	^ analysis1
]

{ #category : #accessing }
SAMutationCoverageDSpotSelection >> astHelper [
	^ SAASTHelper new
]

{ #category : #enumerating }
SAMutationCoverageDSpotSelection >> chooseBestFrom: theList notIncludedIn: result [
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
SAMutationCoverageDSpotSelection >> cleanUp: generatedClass [
	generatedClass testSelectors
		do: [ :sel | generatedClass removeSelector: sel ]
]

{ #category : #cleanup }
SAMutationCoverageDSpotSelection >> infoPragmaFrom: aCovered [
	^ aCovered smallAmpInfoText
]

{ #category : #'as yet unclassified' }
SAMutationCoverageDSpotSelection >> initialAnalysisFor: testClasses targets: targetClasses ignore: aListOfMethods [
	| analysis1 |
	analysis1 := self analysisFor: testClasses targets: targetClasses ignore: aListOfMethods.
	uncovered := analysis1 generalResult aliveMutants.
	^ analysis1
]

{ #category : #'private-debugging' }
SAMutationCoverageDSpotSelection >> matrixFromMutalk: aResult [
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
SAMutationCoverageDSpotSelection >> mutalkRun: aPopulation [
	| testClasses testClass targetClasses pages |
	testClass := aPopulation atRandom testClass.
	targetClasses := aPopulation atRandom testTargets.
	pages := self split: aPopulation page: 100.
	testClasses := pages
		collect: [ :aPage | 
			self astHelper
				buildTestClassWith: (aPopulation collect: [ :tcase | tcase testMethod ])
				using: testClass ].
	^ self mutalkRunClass: testClasses targetClasses: targetClasses
]

{ #category : #'as yet unclassified' }
SAMutationCoverageDSpotSelection >> mutalkRunClass: testClasses targetClasses: targetClasses [
	| analysis1 result wins |
	targetClasses
		do: [ :targetClass | self astHelper disableDeprecationsOn: targetClass ].
	analysis1 := MutationTestingAnalysis
		testCasesFrom: testClasses
		mutating: targetClasses
		using: MutantOperator contents
		with: AllTestsMethodsRunningMutantEvaluationStrategy new
		with:
			(SmallAmpMutationsGenerationStrategy new
				mutants: (uncovered collect: #mutant)).
	wins := self allOpenedWindows.
	result := analysis1 runSmallAmpVerbose.
	config debug
		ifTrue: [ result
				ifFalse: [ self halt ] ].
	targetClasses
		do: [ :targetClass | self astHelper enableDeprecationsOn: targetClass ].
	testClasses do: [:newTestClass | self cleanUp: newTestClass].
	self closeAllWindowsBut: wins.
	Stdio stdout
		nextPutAll: Time nowUTC print24;
		nextPutAll: String space;
		nextPutAll: 'Mutalk ran ';
		nextPutAll: result asString;
		lf;
		flush.
	^ analysis1
]

{ #category : #enumerating }
SAMutationCoverageDSpotSelection >> select: aPopulation [
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
