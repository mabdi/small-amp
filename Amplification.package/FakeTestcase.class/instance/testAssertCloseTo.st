tests
testAssertCloseTo
	self assert: 10 closeTo: 10.
	self assert: 10.00001 closeTo: 10.
	self assert: 29.000004 closeTo: 29.