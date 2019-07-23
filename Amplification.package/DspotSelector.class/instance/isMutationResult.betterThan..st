testing
isMutationResult: analysis1 betterThan: analysis2
	| kills1 kills2 |
	kills1 := analysis1 generalResult killedMutants
		collect: [ :item | item mutant modifiedSource ].
	kills2 := analysis2 generalResult killedMutants
		collect: [ :item | item mutant modifiedSource ].
	^ (kills1 allSatisfy: [ :item | kills2 includes: item ])
		and: [ kills2 anySatisfy: [ :item | (kills1 includes: item) not  ] ]