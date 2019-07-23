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
	self observe: Array name: #Array id: 1.
	self
		observeResult: tmp1
		receiver: Array
		selector: #with:
		name: #tmp1
		id: 2'