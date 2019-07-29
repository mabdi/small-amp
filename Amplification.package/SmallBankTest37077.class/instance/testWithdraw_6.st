as yet unclassified
testWithdraw_6
	| b |
	b := SmallBank new.
	self assert: b balance equals: 0.
	b deposit: SmallInteger minVal.
	self assert: b balance equals: -1152921504606846976.
	b withdraw: 30.
	self assert: b balance equals: -1152921504606846976