initialization
observeAfter: aSelector with: anArray in: aReceiver return: aReturn
	profile at: aSelector ifAbsentPut: OrderedCollection new.
	(profile at: aSelector)
		addAfterArgs: (self stateCapture:anArray)
		state: (self stateCapture: aReceiver)
		returns: (self stateCapture: aReturn)