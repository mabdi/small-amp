enumerating
doSelect: aPopulation selected: aPopulationAll
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
		select: [ :res | res result failures isEmpty ])
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