as yet unclassified
testDeposit_1_1_1
	| b tmp1 tmp2 tmp3 tmp4 tmp1 tmp2 tmp3 tmp4 tmp5 tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp1 := b balance = 1.
	self assert: tmp1 asString equals: 'false'.
	self assert: tmp1 asString equals: 'false'.
	tmp1 := b balance = 1.
	tmp2 := tmp1 asString = 'false'.
	self assert: tmp2 asString equals: 'true'.
	tmp1 := b deposit: 11.
	tmp2 := tmp1 balance = 11.
	tmp3 := tmp2 asString = 'true'.
	self assert: tmp3 asString equals: 'true'.
	self assert: tmp3 asString equals: 'true'.
	tmp2 := b balance = 11.
	tmp3 := tmp2 asString = 'true'.
	tmp4 := tmp3 asString = 'true'.
	self assert: tmp4 asString equals: 'true'.
	tmp3 := b deposit: 100.
	tmp4 := tmp3 balance = 111.
	tmp5 := tmp4 asString = 'true'.
	self assert: tmp5 asString equals: 'true'.
	tmp4 := b balance = 110.
	tmp5 := tmp4 asString = 'false'.
	tmp6 := tmp5 asString = 'true'.
	self assert: tmp6 asString equals: 'true'