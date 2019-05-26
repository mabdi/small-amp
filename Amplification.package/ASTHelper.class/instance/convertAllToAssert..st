removing
convertAllToAssert: aMethod
	^ (AssertTransform
		convertAllToAssert: aMethod parseTree
		transformers: (AssertTransform allSubclasses collect: [ :each | each new ]))
		formattedCode