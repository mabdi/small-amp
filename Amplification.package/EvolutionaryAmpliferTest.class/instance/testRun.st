tests
testRun
	(Amplification
		initializeWithTests:
			{(#testTargets -> {SmallBank}).
			(#testClass -> SmallBankTests).
			(#GAIteration -> 2)} asDictionary) launch