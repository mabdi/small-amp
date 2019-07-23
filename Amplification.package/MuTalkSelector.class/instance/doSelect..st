enumerating
doSelect: aPopulation
	| selectedTests newTestClass analysis1 killSelectors testClass targetClasses |
	selectedTests := OrderedCollection new.
	testClass := aPopulation atRandom testClass.
	targetClasses := aPopulation atRandom testTargets.
	newTestClass := ASTHelper uniqueInstance
		buildAnTestClassWith: (aPopulation collect: [ :tcase | tcase testMethodModified  ])
		using: testClass.
	analysis1 := MutationTestingAnalysis
		testCasesFrom: {newTestClass}
		mutating: targetClasses
		using: MutantOperator contents
		with: AllTestsMethodsRunningMutantEvaluationStrategy new.
	analysis1 run.
	newTestClass removeFromSystem.
	killSelectors := analysis1 generalResult killedMutants
		collect: [ :item | 
			aPopulation
				detect: [ :pp | pp selector = item result failures atRandom selector ] ].
	killSelectors
		do: [ :item | 
			selectedTests
				detect: [ :x | x selector = item selector ]
				ifNone: [ selectedTests add: item ] ].
	^ selectedTests