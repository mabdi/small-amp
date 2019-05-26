actions
doSelection: aPopulation basedOn: analysis0
	| analysis1 newTestClass selectedTests |
	selectedTests := OrderedCollection new.
	newTestClass := self
		makeTestClass: (aPopulation collect: [ :tcase | tcase testMethodNewAssert ]).
	analysis1 := MutationTestingAnalysis
		testCasesFrom: {newTestClass}
		mutating: self targetClasses
		using: MutantOperator contents
		with: AllTestsMethodsRunningMutantEvaluationStrategy new.
	analysis1 run.
	self halt.
	^ selectedTests
		collect: [ :obj | 
			TestMethodObject
				withClass: obj testClass
				method: obj testMethodNewAssert
				targets: obj testTarget ] ""