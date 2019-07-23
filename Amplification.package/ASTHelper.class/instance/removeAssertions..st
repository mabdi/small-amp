removing
removeAssertions: aMethod
	^ (AssertTransform
		removeAssertionsNoExtract: (RBParser parseMethod: aMethod)
		transformers: (AssertTransform allSubclasses collect: [ :each | each new ]))
		formattedCode