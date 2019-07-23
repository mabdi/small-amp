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
	self observe: foo name: #foo id: 1.
	self
		observeResult: a
		receiver: foo
		selector: #bar
		name: #a
		id: 2.
	tmp1 := Array
		with: 1;
		with: 2.
	self observe: Array name: #Array id: 3.
	self
		observeResult: tmp1
		receiver: Array
		selector: #with:
		name: #tmp1
		id: 4'