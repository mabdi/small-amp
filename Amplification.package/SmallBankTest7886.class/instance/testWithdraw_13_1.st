as yet unclassified
testWithdraw_13_1
	| b tmp_cw7J1vGRED1 tmp_D6NR2ZxHfA2 tmp_n1vd9ayWPc3 tmp_kIABYF1Dxe4 tmp_HycTDz3gDJ1 tmp_DC3ocrgODB2 tmp_SSWeidkuAe3 tmp_7KA046Leul4 tmp_mY8dUFZO805 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp_HycTDz3gDJ1 := b balance = 1.
	self assert: tmp_HycTDz3gDJ1 asString equals: 'false'.
	tmp_cw7J1vGRED1 := b deposit: -1152921504606846976.
	self assert: tmp_cw7J1vGRED1 balance equals:  -1152921504606846976.
	tmp_DC3ocrgODB2 := tmp_cw7J1vGRED1 balance = -1152921504606846976.
	self assert: tmp_DC3ocrgODB2 asString equals: 'true'.
	tmp_D6NR2ZxHfA2 := b balance = -1152921504606846976.
	self assert: tmp_D6NR2ZxHfA2 asString equals: 'true'.
	tmp_SSWeidkuAe3 := tmp_D6NR2ZxHfA2 asString = 'true'.
	self assert: tmp_SSWeidkuAe3 asString equals: 'true'.
	tmp_n1vd9ayWPc3 := b withdraw: 30.
	self assert: tmp_n1vd9ayWPc3 balance equals:  -1152921504606846976.
	tmp_7KA046Leul4 := tmp_n1vd9ayWPc3 balance = -1152921504606846976.
	self assert: tmp_7KA046Leul4 asString equals: 'true'.
	tmp_kIABYF1Dxe4 := b balance = 70.
	self assert: tmp_kIABYF1Dxe4 asString equals: 'false'.
	tmp_mY8dUFZO805 := tmp_kIABYF1Dxe4 asString = 'false'.
	self assert: tmp_mY8dUFZO805 asString equals: 'true'