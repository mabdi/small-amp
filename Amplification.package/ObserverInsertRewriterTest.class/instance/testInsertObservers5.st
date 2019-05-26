tests
testInsertObservers5
	node := RBParser
		parseMethod:
			'foo
	| tmp1 tmp2 |
	tmp1 := foo bar.
	tmp2 := Array
		with: 1;
		with: 2'.
	visitor doYourJob: node.
	self
		assert: node formattedCode
		equals:
			'foo
	| tmp1 tmp2 |
	tmp1 := foo bar.
	self observe: tmp1 name: #tmp1 id: 1.
	self observe: foo name: #foo id: 2.
	tmp2 := Array
		with: 1;
		with: 2.
	self observe: tmp2 name: #tmp2 id: 3'