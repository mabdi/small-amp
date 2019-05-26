tests
testInsertObservers1
	node := RBParser
		parseMethod:
			'foo
	a := 1'.
	visitor doYourJob: node.
	self
		assert: node formattedCode
		equals:
			'foo
	a := 1'