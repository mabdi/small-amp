actions
assertionAmplify: aMethod
	^ aMethod
		testMethodModified:
			(self assertAmplifier
				doAssertionAmplification: aMethod testMethodModified
				within: aMethod testClass)