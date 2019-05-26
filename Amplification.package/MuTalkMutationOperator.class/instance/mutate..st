removing
mutate: aMethod
	| mutations tempClass |
	mutations := OrderedCollection new.
	tempClass := ASTHelper uniqueInstance
		buildAnTestClassWith: {aMethod}
		using: TestCase.
	mutations
		addAll:
			((AllMutationsGenerationStrategy new
				mutationsFor: (tempClass methods detect: [ :mtd | mtd selector beginsWith: 'test' ])
				usingAll: self operators
				logginIn: NullMutationTestingAnalysisLogger new)
				collect: [ :mtd | mtd modifiedSource ]).
	tempClass removeFromSystem.
	^ self renameMutations: mutations