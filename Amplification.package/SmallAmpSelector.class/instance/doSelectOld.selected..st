enumerating
doSelectOld: aPopulation selected: aPopulationAll
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