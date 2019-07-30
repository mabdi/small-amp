as yet unclassified
testWithdraw_7
	| b |
	b := SmallBank new.
	b deposit: 0.
	self assert: b balance equals: 0.
	b withdraw: 30.
	self assert: b balance equals: 0