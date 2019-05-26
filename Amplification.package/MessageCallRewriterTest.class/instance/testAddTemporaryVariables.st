tests
testAddTemporaryVariables
	node := RBParser parseMethod: 'foo ^ 1'.
	visitor addTemporaryVariables: 3 to: node.
	self
		assert: (node formattedCode includesSubstring: '| tmp1 tmp2 tmp3 |')