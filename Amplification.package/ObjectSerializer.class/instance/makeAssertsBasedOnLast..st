asserting
makeAssertsBasedOnLast: theLast
	^ self class
		makeAssertName: (dictionary at: #name)
		value: dictionary
		last: nil "disable differential"