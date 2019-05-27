as yet unclassified
testWithdraw_13_39
	| b tmp_cw7J1vGRED1 tmp_D6NR2ZxHfA2 tmp_n1vd9ayWPc3 tmp_kIABYF1Dxe4 tmp_x93payGEUy1 tmp_fkHNglGCH32 tmp_reeDPTQ4iL3 tmp_tEE9lCRmLh4 tmp_RwnHUbkEzG5 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp_x93payGEUy1 := b balance = 0.
	self assert: tmp_x93payGEUy1 asString equals: 'true'.
	tmp_cw7J1vGRED1 := b deposit: -1152921504606846976.
	self assert: tmp_cw7J1vGRED1 balance equals:  -1152921504606846976.
	tmp_fkHNglGCH32 := tmp_cw7J1vGRED1 balance = -1152921504606846976.
	self assert: tmp_fkHNglGCH32 asString equals: 'true'.
	tmp_D6NR2ZxHfA2 := b balance = -1152921504606846976.
	self assert: tmp_D6NR2ZxHfA2 asString equals: 'true'.
	tmp_reeDPTQ4iL3 := tmp_D6NR2ZxHfA2 asString = 'true'.
	self assert: tmp_reeDPTQ4iL3 asString equals: 'true'.
	tmp_n1vd9ayWPc3 := b withdraw: -1152921504606846976.
	self assert: tmp_n1vd9ayWPc3 balance equals: 0.
	tmp_tEE9lCRmLh4 := tmp_n1vd9ayWPc3 balance = -1152921504606846976.
	self assert: tmp_tEE9lCRmLh4 asString equals: 'false'.
	tmp_kIABYF1Dxe4 := b balance = 70.
	self assert: tmp_kIABYF1Dxe4 asString equals: 'false'.
	tmp_RwnHUbkEzG5 := tmp_kIABYF1Dxe4 asString = 'false'.
	self assert: tmp_RwnHUbkEzG5 asString equals: 'true'