actions
assertionAmplify: aMethod
	^ aMethod
		testMethodNewAssert:
			(self assertAmplifier
				doAssertionAmplification: aMethod testMethodMutated
				within: aMethod testClass)