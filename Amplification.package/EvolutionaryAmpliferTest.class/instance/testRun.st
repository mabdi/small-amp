tests
testRun
	(Amplification
		initializeWithTests:
			{(#testTargets -> {SmallBank}).
			(#testClass -> SmallBankTest).
			(#GAIteration -> 2)} asDictionary) launch