actions
preStartActions
	| result |
	result := testClass suite run.
	testTargets do: [ :atarg | atarg methods do: [ :mtd |ObservationProxy fixMethod: mtd ] ].
	testMethods := result passed
		collect: [ :passed | 
			(testClass methods detect: [ :m | m selector = passed selector ])
				sourceCode ].
	improvmentAlgorithm testMethods: testMethods