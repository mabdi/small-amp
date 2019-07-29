as yet unclassified
testWithdraw_6_4
	| b |
	b := SmallBank new.
	self assert: b balance equals: 0.
	b deposit: SmallInteger minVal.
	self assert: b balance equals: -1152921504606846976.
	b withdraw: 15.
	self assert: b balance equals: -1152921504606846976