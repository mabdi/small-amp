actions
preStartActions
	| result |
	result := testClass suite run.
	testMethods := result passed
		collect:
			[ :passed | (testClass methods detect: [ :m | m selector = passed selector ]) sourceCode].
	improvmentAlgorithm testMethods: testMethods