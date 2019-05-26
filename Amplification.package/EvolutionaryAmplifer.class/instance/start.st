accessing
start
	" Here is the main loop of program."

	| population analysis0 |
	analysis0 := MutationTestingAnalysis
		testCasesFrom: {self testClass}
		mutating: self targetClasses
		using: MutantOperator contents
		with: AllTestsMethodsRunningMutantEvaluationStrategy new.
	analysis0 run.
	population := testMethods
		collect: [ :tcase | 
			TestMethodObject
				withClass: testClass
				method: tcase
				targets: targetClasses ].
	iterations
		timesRepeat: [ population do: [ :tcase | self removeAssrtion: tcase ].
			
			population := (population
				collect: [ :tcase | self doMutation: tcase ]) flattened.
			population := population
				collect: [ :tcase | self assertionAmplify: tcase ].
			population := self doSelection: population basedOn: analysis0 ].
	^ self
		makeTestClass: (population collect: [ :tcase | tcase testMethodNewAssert ])