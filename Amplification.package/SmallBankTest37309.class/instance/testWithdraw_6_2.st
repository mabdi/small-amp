as yet unclassified
testWithdraw_6_2
	| b |
	b := SmallBank new.
	b deposit: SmallInteger minVal.
	self assert: b balance equals: -1152921504606846976.
	b withdraw: 29.
	self assert: b balance equals: -1152921504606846976