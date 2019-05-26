tests
testInsertObservers3
	node := RBParser
		parseMethod:
			'foo
	| tmp1 |
	a := 1.
	tmp1 := Array
		with: 1;
		with: 2'.
	visitor doYourJob: node.
	self
		assert: node formattedCode
		equals:
			'foo
	| tmp1 |
	a := 1.
	tmp1 := Array
		with: 1;
		with: 2.
	self observe: tmp1 name: #tmp1 id: 1'