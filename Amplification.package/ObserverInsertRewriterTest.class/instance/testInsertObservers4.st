tests
testInsertObservers4
	node := RBParser
		parseMethod:
			'foo
	| tmp1 |
	a := foo bar.
	tmp1 := Array
		with: 1;
		with: 2'.
	visitor doYourJob: node.
	self
		assert: node formattedCode
		equals:
			'foo
	| tmp1 |
	a := foo bar.
	self observe: a name: #a id: 1.
	self observe: foo name: #foo id: 2.
	tmp1 := Array
		with: 1;
		with: 2.
	self observe: tmp1 name: #tmp1 id: 3'