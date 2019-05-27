as yet unclassified
testWithdraw_13_12
	| b tmp_cw7J1vGRED1 tmp_D6NR2ZxHfA2 tmp_n1vd9ayWPc3 tmp_kIABYF1Dxe4 tmp_gZGo4EvqkS1 tmp_AQQDxu8mq02 tmp_IJRJ1D3Or43 tmp_4X48MFaWGK4 tmp_mHaYyGcrVr5 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp_gZGo4EvqkS1 := b balance = 0.
	self assert: tmp_gZGo4EvqkS1 asString equals: 'true'.
	tmp_cw7J1vGRED1 := b deposit: 1152921504606846975.
	self assert: tmp_cw7J1vGRED1 balance equals: 1152921504606846975.
	tmp_AQQDxu8mq02 := tmp_cw7J1vGRED1 balance = 1152921504606846975.
	self assert: tmp_AQQDxu8mq02 asString equals: 'true'.
	tmp_D6NR2ZxHfA2 := b balance = 1152921504606846975.
	self assert: tmp_D6NR2ZxHfA2 asString equals: 'true'.
	tmp_IJRJ1D3Or43 := tmp_D6NR2ZxHfA2 asString = 'true'.
	self assert: tmp_IJRJ1D3Or43 asString equals: 'true'.
	tmp_n1vd9ayWPc3 := b withdraw: 30.
	self assert: tmp_n1vd9ayWPc3 balance equals: 1152921504606846945.
	tmp_4X48MFaWGK4 := tmp_n1vd9ayWPc3 balance = 1152921504606846975.
	self assert: tmp_4X48MFaWGK4 asString equals: 'false'.
	tmp_kIABYF1Dxe4 := b balance = 70.
	self assert: tmp_kIABYF1Dxe4 asString equals: 'false'.
	tmp_mHaYyGcrVr5 := tmp_kIABYF1Dxe4 asString = 'false'.
	self assert: tmp_mHaYyGcrVr5 asString equals: 'true'