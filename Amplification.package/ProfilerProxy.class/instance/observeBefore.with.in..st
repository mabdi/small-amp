initialization
observeBefore: aSelector with: anArray in: aReceiver
	profile at: aSelector ifAbsentPut: OrderedCollection new.
	(profile at: aSelector)
		addBeforeArgs: (self stateCapture:anArray)
		state: (self stateCapture: aReceiver)