enumerating
doSelect: aPopulation
	| selectedTests analysis groups |
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
	^ aPopulation
		select: [ :item | 
			
				selectedTests includes: item selector ]