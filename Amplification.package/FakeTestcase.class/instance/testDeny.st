tests
testDeny
	
	| heap |
	heap := Heap new.
	self assert: heap size equals: 0.
	heap add: 3.
	self assert: heap size equals: 1.
	self deny: heap isEmpty.
	self assert: heap first equals: 3.
	heap add: 2.
	self assert: heap size equals: 2.
	self assert: heap first equals: 2