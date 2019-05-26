tests
testFunction2
	node := RBParser parseMethod: 'foo a:=1. Array with:1'.
	visitor visitNode: node.
	self assert: visitor targetNodes size equals: 1