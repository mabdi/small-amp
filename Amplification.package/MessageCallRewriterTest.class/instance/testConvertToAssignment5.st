tests
testConvertToAssignment5
	node := RBParser parseMethod: 'foo foo bar. Array with:1;with:2'.
	visitor doYourJob: node.
	self
		assert: (GeneralHelper renameTempVars: node formattedCode)
		equals:
			'foo
	| tmp1 tmp2 |
	tmp1 := foo bar.
	tmp2 := Array
		with: 1;
		with: 2'