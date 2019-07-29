tests
testRunN100
	| run1 newTest run2 |
	newTest := (Amplification
		initializeWithTests:
			{(#testTargets -> {SmallBank}).
			(#testClass -> SmallBankTest).
			(#GAIteration -> 100)} asDictionary) launch.
	run1 := self mutalkTarget: {SmallBank} testSuite: {SmallBankTest}.
	run2 := self mutalkTarget: {SmallBank} testSuite: {newTest}.
	self
		assert: run2 generalResult mutationScore > run1 generalResult mutationScore