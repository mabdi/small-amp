actions
doSelection: aPopulation
	| analysis1 newTestClass selectedTests killSelectors |
	selectedTests := OrderedCollection new.
	newTestClass := self
		makeTestClass: (aPopulation collect: [ :tcase | tcase testMethodNewAssert ]).
	analysis1 := MutationTestingAnalysis
		testCasesFrom: {newTestClass}
		mutating: self targetClasses
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
		collect: [ :obj | 
			
			TestMethodObject
				withClass: obj testClass
				method: obj testMethodNewAssert
				targets: obj testTargets ]