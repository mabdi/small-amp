as yet unclassified
testWithdraw_7_1
	| b |
	b := SmallBank new.
	b deposit: 1.
	self assert: b balance equals: 1.
	b withdraw: 30.
	self assert: b balance equals: 1