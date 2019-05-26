tests
testFunction3
	node := RBParser parseMethod: 'foo a:= 1. Array with:1;with:2'.
	visitor visitNode: node.
	self assert: visitor targetNodes size equals: 1