removing
removeAssertionsOld: aMethod
	^ (AssertTransform
		removeAssertions: (RBParser parseMethod: aMethod)
		transformers: (AssertTransform allSubclasses collect: [ :each | each new ]))
		formattedCode