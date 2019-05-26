tests
testFunction4
	node := RBParser parseMethod: 'foo a:= foo bar. Array with:1;with:2'.
	visitor visitNode: node.
	self assert: visitor targetNodes size equals: 1