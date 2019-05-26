tests
testInsertObservers2
	node := RBParser
		parseMethod:
			'foo
	| tmp1 |
	a := 1.
	tmp1 := Array with: 1'.
	visitor doYourJob: node.
	self
		assert: node formattedCode
		equals:
			'foo
	| tmp1 |
	a := 1.
	tmp1 := Array with: 1.
	self observe: tmp1 name: #tmp1 id: 1'