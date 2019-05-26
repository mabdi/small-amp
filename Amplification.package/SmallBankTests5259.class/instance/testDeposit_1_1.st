as yet unclassified
testDeposit_1_1
	| b tmp_uuiSfv3szV1 tmp_nx5DToF3pP2 tmp_IfZCPMcrIp3 tmp_cjl8ItyxOy4 tmp_teZ19mCe1f1 tmp_YEUMVsUJln2 tmp_7EeAwyWBra3 tmp_23RNU3GoK14 tmp_P2u5z45E165 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp_uuiSfv3szV1 := b balance = 1.
	self assert: tmp_uuiSfv3szV1 asString equals: 'false'.
	tmp_uuiSfv3szV1 := b deposit: 11.
	tmp_nx5DToF3pP2 := tmp_uuiSfv3szV1 balance = 11.
	self assert: tmp_nx5DToF3pP2 asString equals: 'true'.
	tmp_nx5DToF3pP2 := b balance = 11.
	tmp_IfZCPMcrIp3 := tmp_nx5DToF3pP2 asString = 'true'.
	self assert: tmp_IfZCPMcrIp3 asString equals: 'true'.
	tmp_IfZCPMcrIp3 := b deposit: 100.
	tmp_cjl8ItyxOy4 := tmp_IfZCPMcrIp3 balance = 111.
	self assert: tmp_cjl8ItyxOy4 asString equals: 'true'.
	tmp_cjl8ItyxOy4 := b balance = 110.
	tmp_teZ19mCe1f1 := tmp_cjl8ItyxOy4 asString = 'false'.
	self assert: tmp_teZ19mCe1f1 asString equals: 'true'