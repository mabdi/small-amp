as yet unclassified
testWithdraw_13_39_81
	| b tmp1 tmp2 tmp3 tmp4 tmp1 tmp2 tmp3 tmp4 tmp5 tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp1 := b balance = 0.
	self assert: tmp1 asString equals: 'true'.
	self assert: tmp1 asString equals: 'true'.
	tmp1 := b balance = 0.
	tmp2 := tmp1 asString = 'true'.
	self assert: tmp2 asString equals: 'true'.
	tmp1 := b deposit: -1152921504606846976.
	tmp2 := tmp1 balance = -1152921504606846976.
	tmp3 := tmp2 asString = 'true'.
	self assert: tmp3 asString equals: 'true'.
	self assert: tmp3 asString equals: 'true'.
	tmp2 := b balance = -1152921504606846976.
	tmp3 := tmp2 asString = 'true'.
	tmp4 := tmp3 asString = 'true'.
	self assert: tmp4 asString equals: 'true'.
	tmp3 := b withdraw: -1152921504606846976.
	tmp4 := tmp3 balance = -1152921504606846976.
	tmp5 := tmp4 asString = 'false'.
	self assert: tmp5 asString equals: 'true'.
	self assert: tmp5 asString equals: 'true'.
	tmp4 := b balance = 0.
	tmp5 := tmp4 asString = 'false'.
	tmp6 := tmp5 asString = 'true'.
	self assert: tmp6 asString equals: 'false'