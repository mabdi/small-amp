accessing
initializeWithTests: dicConfig
	testTargets := dicConfig at: #testTargets.
	testClass := dicConfig at: #testClass.
	testMethods := testClass allTestSelectors.
	improvmentAlgorithm := EvolutionaryAmplifer
		initializeWith: testClass
		target: testTargets
		iterations: (dicConfig at: #GAIteration ifAbsent: 1000)
		popSize: (dicConfig at: #GAPopsize ifAbsent: 100).
	improvmentAlgorithm testMethods: testMethods