tests
testFunction5
	node := RBParser parseMethod: 'foo foo bar. Array with:1;with:2'.
	visitor visitNode: node.
	self assert: visitor targetNodes size equals: 2