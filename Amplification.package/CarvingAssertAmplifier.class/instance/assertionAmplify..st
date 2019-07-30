as yet unclassified
assertionAmplify: aMethod
	^ aMethod
		testMethodModified:
			(self 
				doAssertionAmplification: aMethod testMethodModified
				within: aMethod testClass)