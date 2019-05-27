tests
testConvertToAssignment3
	node := RBParser parseMethod: 'foo a:= 1. Array with:1;with:2'.
	visitor doYourJob: node.
	self
		assert: (GeneralHelper renameTempVars: node formattedCode)
		equals:
			'foo
	| tmp1 |
	a := 1.
	tmp1 := Array
		with: 1;
		with: 2'