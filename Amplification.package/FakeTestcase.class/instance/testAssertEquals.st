tests
testAssertEquals
	| array |
	array := #[1 2 3 4 5 6 7 8 9 10 11 1 2 3 4 5 6 7 8 0 0].
	self assert: (array indexOf: 1 startingAt: 10) equals: 12.
	self assert: (array indexOf: 17 startingAt: 10) equals: 0