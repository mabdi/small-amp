changing suspended state
run: aSelector with: anArray in: aReceiver
	| result |
	action observeBefore: aSelector with: anArray in: aReceiver.
	result := aReceiver withArgs: anArray executeMethod: method.
	action
		observeAfter: aSelector
		with: anArray
		in: aReceiver
		return: result.
	^ result