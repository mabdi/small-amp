Class {
	#name : #SmallAmpSelector,
	#superclass : #AbstractSelector,
	#category : #'Amplification-Core'
}

{ #category : #enumerating }
SmallAmpSelector >> doSelect: aPopulation selected: aPopulationAll [
	| selectedTests analysis groups result analysis2 survives |
	
	selectedTests := OrderedCollection new.
	analysis := self mutalkRun: aPopulation.
	groups := aPopulation
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
		select: [ :item | selectedTests includes: item selector ].
	analysis2 := self mutalkRun: aPopulationAll , result.
	survives := (analysis2 particularResults
		select: [ :res | res result isNotNil and: [ res result failures isEmpty ] ])
		collect: [ :item | item mutant modifiedSource ].
	analysis particularResults
		do: [ :item | 
			survives
				detect: [ :s | s = item mutant modifiedSource ]
				ifFound: [ :s | 
					item result failures
						ifNotEmpty: [ selectedTests add: item result failures atRandom selector ] ] ].
	result := aPopulation
		select: [ :item | selectedTests includes: item selector ].
	"extrakills := Dictionary new.
	analysis
		keysAndValuesDo: [ :key :val | 
			((val generalResult killedMutants
				collect: [ :item | item mutant modifiedSource ]) asSet
				difference: kills)
				do: [ :killed | 
					extrakills at: killed ifAbsentPut: [ OrderedCollection new ].
					(extrakills at: killed) add: key ] ].
	selectedTests addAll: (extrakills collect: [ :item | item atRandom ])."
	^ result
]

{ #category : #enumerating }
SmallAmpSelector >> doSelectOld: aPopulation selected: aPopulationAll [
	| selectedTests analysis groups kills extrakills result analysis2 |
	selectedTests := OrderedCollection new.
	analysis := (aPopulation
		collect: [ :testCase | testCase selector -> (self mutalkRun: {testCase}) ]
		displayingProgress: 'Selection: Mutation Analysis') asDictionary.
	groups := Dictionary new.
	(aPopulation
		select: [ :tcase | tcase selectorOriginal = tcase selector ])
		do: [ :tcase | groups at: tcase selector put: OrderedCollection new ].
	aPopulation
		do: [ :tcase | (groups at: tcase selectorOriginal) add: tcase selector ].
	groups
		keysDo: [ :key | 
			(groups at: key)
				do: [ :item | 
					(self
						isMutationResult: (analysis at: item)
						betterThan: (analysis at: key))
						ifTrue: [ selectedTests add: item ] ] ].
	kills := (selectedTests
		collect: [ :stest | 
			(analysis at: stest) generalResult killedMutants
				collect: [ :item | item mutant modifiedSource ] ]) flattened asSet.
	result := aPopulation
		select: [ :item | selectedTests includes: item selector ].
	analysis2 := self mutalkRun: aPopulationAll , result.
	self halt.
	"extrakills := Dictionary new.
	analysis
		keysAndValuesDo: [ :key :val | 
			((val generalResult killedMutants
				collect: [ :item | item mutant modifiedSource ]) asSet
				difference: kills)
				do: [ :killed | 
					extrakills at: killed ifAbsentPut: [ OrderedCollection new ].
					(extrakills at: killed) add: key ] ].
	selectedTests addAll: (extrakills collect: [ :item | item atRandom ])."
	^ result
]

{ #category : #testing }
SmallAmpSelector >> isMutationResult: mutatedSelector betterThan: parentSelector basedOn: analysis [
	| pkilled mkilled |
	pkilled := (analysis particularResults
		select: [ :res | 
			res result failures
				anySatisfy: [ :meth | meth selector = parentSelector ] ])
		collect: [ :item | item mutant modifiedSource ].
	mkilled := (analysis particularResults
		select: [ :res | 
			res result failures
				anySatisfy: [ :meth | meth selector = mutatedSelector ] ])
		collect: [ :item | item mutant modifiedSource ].
	^ (pkilled allSatisfy: [ :item | mkilled includes: item ])
		and: [ mkilled anySatisfy: [ :item | (pkilled includes: item) not ] ]
]

{ #category : #testing }
SmallAmpSelector >> isMutationResultOld: analysis1 betterThan: analysis2 [
	| kills1 kills2 |
	kills1 := analysis1 generalResult killedMutants
		collect: [ :item | item mutant modifiedSource ].
	kills2 := analysis2 generalResult killedMutants
		collect: [ :item | item mutant modifiedSource ].
	^ (kills1 allSatisfy: [ :item | kills2 includes: item ])
		and: [ kills2 anySatisfy: [ :item | (kills1 includes: item) not ] ]
]

{ #category : #'as yet unclassified' }
SmallAmpSelector >> matrixFromMutalk: aResult [
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
SmallAmpSelector >> mutalkRun: aPopulation [
	| testClass targetClasses newTestClass analysis1 |
	testClass := aPopulation atRandom testClass.
	targetClasses := aPopulation atRandom testTargets.
	newTestClass := ASTHelper uniqueInstance
		buildAnTestClassWith: (aPopulation collect: [ :tcase | tcase testMethodModified ])
		using: testClass.
	analysis1 := MutationTestingAnalysis
		testCasesFrom: {newTestClass}
		mutating: targetClasses
		using: MutantOperator contents
		with: AllTestsMethodsRunningMutantEvaluationStrategy new.
	analysis1 run.
	ASTHelper uniqueInstance removeClass: newTestClass  source: self class name..
	^ analysis1
]
