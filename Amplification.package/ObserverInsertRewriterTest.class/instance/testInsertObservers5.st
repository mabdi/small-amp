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
	self observe: foo name: #foo id: 1.
	self
		observeResult: tmp1
		receiver: foo
		selector: #bar
		name: #tmp1
		id: 2.
	tmp2 := Array
		with: 1;
		with: 2.
	self observe: Array name: #Array id: 3.
	self
		observeResult: tmp2
		receiver: Array
		selector: #with:
		name: #tmp2
		id: 4'