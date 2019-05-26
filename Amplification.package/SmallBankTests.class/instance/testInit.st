tests
testInit
	| b |
	b := SmallBank new .self assert: b balance equals: 0