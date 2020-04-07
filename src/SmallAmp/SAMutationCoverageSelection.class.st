Class {
	#name : #SAMutationCoverageSelection,
	#superclass : #SAAbstractSelection,
	#instVars : [
		'uncovered'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #enumerating }
SAMutationCoverageSelection >> allselect: aPopulation uncovered: uncoveredList [
	| analysis alives result newKills |
	result := OrderedCollection new.
	analysis := self mutalkRun: aPopulation mutants: uncoveredList.
	alives := analysis generalResult aliveMutants.
	newKills := uncoveredList
		reject: [ :s | 
			alives
				anySatisfy: [ :z | z mutant modifiedSource = s mutant modifiedSource ] ].
	uncovered := uncoveredList
		select: [ :s | 
			alives
				anySatisfy: [ :z | z mutant modifiedSource = s mutant modifiedSource ] ].
	analysis particularResults
		do: [ :item | 
			newKills
				detect: [ :s | s mutant modifiedSource = item mutant modifiedSource ]
				ifFound: [ :s | 
					item result
						ifNotNil: [ item result failures
								ifNotEmpty: [ | sels |
									sels := item result failures collect: #selector.
									result
										addAll:
											((aPopulation select: [ :p | sels includes: p selector ])
												reject: [ :s2 | result anySatisfy: [ :s3 | s3 testMethod = s2 testMethod ] ]) ] ] ] ].
	^ result
]

{ #category : #accessing }
SAMutationCoverageSelection >> astHelper [
	^ SAASTHelper new
]

{ #category : #enumerating }
SAMutationCoverageSelection >> chooseBestFrom: theList notIncludedIn: result [
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
SAMutationCoverageSelection >> cleanUp: generatedClass [
	config debug ifFalse: [ 
		self astHelper removeClass: generatedClass source: self class name ]
]

{ #category : #'private-debugging' }
SAMutationCoverageSelection >> matrixFromMutalk: aResult [
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
SAMutationCoverageSelection >> mutalkRun: aPopulation mutants: uncoveredList [
	| testClass targetClasses newTestClass analysis1 result wins |
	testClass := aPopulation atRandom testClass.
	targetClasses := aPopulation atRandom testTargets.
	newTestClass := self astHelper
		buildTestClassWith: (aPopulation collect: [ :tcase | tcase testMethod ])
		using: testClass.
	analysis1 := MutationTestingAnalysis
		testCasesFrom: {newTestClass}
		mutating: targetClasses
		using: MutantOperator contents
		with: AllTestsMethodsRunningMutantEvaluationStrategy new
		with:
			(SmallAmpMutationsGenerationStrategy new
				mutants: (uncoveredList collect: #mutant)).
	wins := self allOpenedWindows.
	result := analysis1 runSmallAmpVerbose.
	result
		ifTrue: [ self cleanUp: newTestClass. self closeAllWindowsBut: wins ].
	^ analysis1
]

{ #category : #enumerating }
SAMutationCoverageSelection >> oldselect: aPopulation uncovered: uncoveredList [
	| analysis alives result newKills |
	result := OrderedCollection new.
	analysis := self mutalkRun: aPopulation mutants: uncoveredList.
	alives := analysis generalResult aliveMutants.
	newKills := uncoveredList
		reject: [ :s | 
			alives
				anySatisfy: [ :z | z mutant modifiedSource = s mutant modifiedSource ] ].
	uncovered := uncoveredList
		select: [ :s | 
			alives
				anySatisfy: [ :z | z mutant modifiedSource = s mutant modifiedSource ] ].
	analysis particularResults
		do: [ :item | 
			newKills
				detect: [ :s | s mutant modifiedSource = item mutant modifiedSource ]
				ifFound: [ :s | 
					item result
						ifNotNil: [ item result failures
								ifNotEmpty: [ | sels |
									sels := item result failures collect: #selector.
									result
										add:
											(self
												chooseBestFrom: (aPopulation select: [ :p | sels includes: p selector ])
												notIncludedIn: result) ] ] ] ].
	^ result
]

{ #category : #enumerating }
SAMutationCoverageSelection >> select: aPopulation uncovered: uncoveredList [
	| analysis alives result newKills |
	result := OrderedCollection new.
	analysis := self mutalkRun: aPopulation mutants: uncoveredList.
	alives := analysis generalResult aliveMutants.
	newKills := uncoveredList
		reject: [ :s | 
			alives
				anySatisfy: [ :z | z mutant modifiedSource = s mutant modifiedSource ] ].
	uncovered := uncoveredList
		select: [ :s | 
			alives
				anySatisfy: [ :z | z mutant modifiedSource = s mutant modifiedSource ] ].
	analysis particularResults
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
									selected ifNotNil: [result add: selected] ] ] ] ].
	^ result reject: #isNil
]

{ #category : #accessing }
SAMutationCoverageSelection >> uncovered [
	^ uncovered
]
