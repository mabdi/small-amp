tests
testConvertToAssignment4
	node := RBParser parseMethod: 'foo a:= foo bar. Array with:1;with:2'.
	visitor doYourJob: node.
	self
		assert: node formattedCode
		equals:
			'foo
	| tmp1 |
	a := foo bar.
	tmp1 := Array
		with: 1;
		with: 2'