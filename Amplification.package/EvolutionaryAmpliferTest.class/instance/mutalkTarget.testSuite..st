as yet unclassified
mutalkTarget: aClass testSuite: aTestSuite
	| analysis1 |
	analysis1 := MutationTestingAnalysis
		testCasesFrom: aTestSuite
		mutating: aClass
		using: MutantOperator contents
		with: AllTestsMethodsRunningMutantEvaluationStrategy new.
	analysis1 run.
	^ analysis1