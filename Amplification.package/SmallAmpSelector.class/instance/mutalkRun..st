as yet unclassified
mutalkRun: aPopulation
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
	newTestClass removeFromSystem.
	^ analysis1