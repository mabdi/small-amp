tests
testAddTemporaryVariables1
	node := RBParser parseMethod: 'foo |a b c | ^ 1'.
	visitor addTemporaryVariables: 3 to: node.
	self
		assert: (node formattedCode includesSubstring: '| a b c tmp1 tmp2 tmp3 |')