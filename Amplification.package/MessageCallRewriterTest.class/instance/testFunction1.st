tests
testFunction1
	node := RBParser parseMethod: 'foo a:=1'.
	visitor visitNode: node.
	self assert: visitor targetNodes size equals: 0