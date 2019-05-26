tests
testRun
	(Amplification
		initializeWithTests:
			{(#testTargets -> {SmallBank}).
			(#testClass -> SmallBankTests)} asDictionary) launch