Class {
	#name : #SAMutationCoverageSelection,
	#superclass : #SAAbstractSelection,
	#instVars : [
		'uncovered'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #accessing }
SAMutationCoverageSelection >> astHelper [
	^ SAASTHelper new
]

{ #category : #enumerating }
SAMutationCoverageSelection >> chooseBestFrom: aList [
	"first select shortest methods
	Then, select minimum change,"

	| shortestLen shorts |
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

{ #category : #testing }
SAMutationCoverageSelection >> isMutationResult: mutatedSelector betterThan: parentSelector basedOn: analysis [
	| pkilled mkilled |
	"TODO I ignore terminated result. have a look to mutalk sourcecode to see why terminated results dont have any result"
	pkilled := (analysis particularResults
		select: [ :res | 
			res result isNotNil
				ifTrue: [ res result failures
						anySatisfy: [ :meth | meth selector = parentSelector ] ]
				ifFalse: [ false ] ])
		collect: [ :item | item mutant modifiedSource ].
	mkilled := (analysis particularResults
		select: [ :res | 
			res result isNotNil
				ifTrue: [ res result failures
						anySatisfy: [ :meth | meth selector = mutatedSelector ] ]
				ifFalse: [ false ] ])
		collect: [ :item | item mutant modifiedSource ].
	^ (pkilled allSatisfy: [ :item | mkilled includes: item ])
		and: [ mkilled anySatisfy: [ :item | (pkilled includes: item) not ] ]
]

{ #category : #'as yet unclassified' }
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
	| testClass targetClasses newTestClass analysis1 result |
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
		with: (SmallAmpMutationsGenerationStrategy new mutants: (uncoveredList collect: #mutant)).
	result := analysis1 runSmallAmp.
	result
		ifTrue: [ self cleanUp: newTestClass ].
	^ analysis1
]

{ #category : #enumerating }
SAMutationCoverageSelection >> select: aPopulation alreadySelected: alreadySelectedPopulation [
	| selectedTests analysis groups result analysis2 survives |
	selectedTests := OrderedCollection new.
	analysis := self mutalkRun: aPopulation.
	"groups := aPopulation
		inject: Dictionary new
		into: [ :gr :tcase | 
			gr at: tcase selectorOriginal ifAbsentPut: [ OrderedCollection new ].
			(gr at: tcase selectorOriginal) add: tcase selector.
			gr ].
	groups
		keysDo: [ :parentSelector | 
			(groups at: parentSelector)
				do: [ :mutatedSelector | 
					(self
						isMutationResult: mutatedSelector
						betterThan: parentSelector
						basedOn: analysis)
						ifTrue: [ selectedTests add: mutatedSelector ] ] ].
	result := aPopulation
		select: [ :item | selectedTests includes: item selector ]."
	analysis2 := self mutalkRun: alreadySelectedPopulation.
	survives := (analysis2 particularResults
		select: [ :res | res result isNotNil and: [ res result failures isEmpty ] ])
		collect: [ :item | item mutant ].
	analysis particularResults
		do: [ :item | 
			survives
				detect: [ :s | s modifiedSource = item mutant modifiedSource ]
				ifFound: [ :s | 
					item result
						ifNotNil: [ item result failures
								ifNotEmpty: [ selectedTests addAll: (item result failures collect: #selector) ] ] ] ].
	uncovered := survives.
	result := aPopulation
		select: [ :item | selectedTests includes: item selector ].
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
								ifNotEmpty: [ | sels |
									sels := item result failures collect: #selector.
									result
										add:
											(self
												chooseBestFrom: (aPopulation select: [ :p | sels includes: p selector ])) ] ] ] ].
	^ result
]

{ #category : #accessing }
SAMutationCoverageSelection >> uncovered [
	^ uncovered
]
