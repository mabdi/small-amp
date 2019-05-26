as yet unclassified
testWithdraw_13_12
	| b tmp_i4zNvD1mVA1 tmp_3TMFTpQDQ52 tmp_ZxNilMYgMT3 tmp_rdE6viuAJE4 tmp_quHqV3Fm6f1 tmp_r01Pccmwa82 tmp_yOdcJ3lKU43 tmp_KekWaf0RSo4 tmp_aAnSo4M8XZ5 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp_quHqV3Fm6f1 := b balance = 0.
	self assert: tmp_quHqV3Fm6f1 asString equals: 'true'.
	tmp_i4zNvD1mVA1 := b deposit: 1152921504606846975.
	self assert: tmp_i4zNvD1mVA1 balance equals: 1152921504606846975.
	tmp_r01Pccmwa82 := tmp_i4zNvD1mVA1 balance = 1152921504606846975.
	self assert: tmp_r01Pccmwa82 asString equals: 'true'.
	tmp_3TMFTpQDQ52 := b balance = 1152921504606846975.
	self assert: tmp_3TMFTpQDQ52 asString equals: 'true'.
	tmp_yOdcJ3lKU43 := tmp_3TMFTpQDQ52 asString = 'true'.
	self assert: tmp_yOdcJ3lKU43 asString equals: 'true'.
	tmp_ZxNilMYgMT3 := b withdraw: 30.
	self assert: tmp_ZxNilMYgMT3 balance equals: 1152921504606846945.
	tmp_KekWaf0RSo4 := tmp_ZxNilMYgMT3 balance = 1152921504606846975.
	self assert: tmp_KekWaf0RSo4 asString equals: 'false'.
	tmp_rdE6viuAJE4 := b balance = 70.
	self assert: tmp_rdE6viuAJE4 asString equals: 'false'.
	tmp_aAnSo4M8XZ5 := tmp_rdE6viuAJE4 asString = 'false'.
	self assert: tmp_aAnSo4M8XZ5 asString equals: 'true'