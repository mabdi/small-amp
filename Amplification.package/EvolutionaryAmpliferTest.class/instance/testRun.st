tests
testRun
	| newTest run1 run2 |
	newTest := (Amplification
		initializeWithTests:
			{(#testTargets -> {SmallBank}).
			(#testClass -> SmallBankTest).
			(#GAIteration -> 2)} asDictionary) launch.
	run1 := self mutalkTarget: {SmallBank} testSuite: {SmallBankTest}.
	run2 := self mutalkTarget: {SmallBank} testSuite: {newTest}.
	self halt.
	self
		assert: run2 generalResult mutationScore > run1 generalResult mutationScore