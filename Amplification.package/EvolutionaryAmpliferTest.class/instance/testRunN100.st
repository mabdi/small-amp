tests
testRunN100
	(Amplification
		initializeWithTests:
			{(#testTargets -> {SmallBank}).
			(#testClass -> SmallBankTest).
			(#GAIteration -> 100)} asDictionary) launch