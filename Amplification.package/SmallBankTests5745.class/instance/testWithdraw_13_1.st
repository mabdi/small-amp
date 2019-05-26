as yet unclassified
testWithdraw_13_1
	| b tmp_J21PlB8MBF1 tmp_ZXEtJFlzWQ2 tmp_CgQCCL3njG3 tmp_40KnAsUUOO4 tmp_KO70fJdxiZ1 tmp_zjQRXnaeIr2 tmp_fT3WS4wEfm3 tmp_tmnFsD4io14 tmp_hw9i4DnCti5 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp_KO70fJdxiZ1 := b balance = 1.
	self assert: tmp_KO70fJdxiZ1 asString equals: 'false'.
	tmp_J21PlB8MBF1 := b deposit: -1152921504606846976.
	self assert: tmp_J21PlB8MBF1 balance equals:  -1152921504606846976.
	tmp_zjQRXnaeIr2 := tmp_J21PlB8MBF1 balance = -1152921504606846976.
	self assert: tmp_zjQRXnaeIr2 asString equals: 'true'.
	tmp_ZXEtJFlzWQ2 := b balance = -1152921504606846976.
	self assert: tmp_ZXEtJFlzWQ2 asString equals: 'true'.
	tmp_fT3WS4wEfm3 := tmp_ZXEtJFlzWQ2 asString = 'true'.
	self assert: tmp_fT3WS4wEfm3 asString equals: 'true'.
	tmp_CgQCCL3njG3 := b withdraw: 30.
	self assert: tmp_CgQCCL3njG3 balance equals:  -1152921504606846976.
	tmp_tmnFsD4io14 := tmp_CgQCCL3njG3 balance = -1152921504606846976.
	self assert: tmp_tmnFsD4io14 asString equals: 'true'.
	tmp_40KnAsUUOO4 := b balance = 70.
	self assert: tmp_40KnAsUUOO4 asString equals: 'false'.
	tmp_hw9i4DnCti5 := tmp_40KnAsUUOO4 asString = 'false'.
	self assert: tmp_hw9i4DnCti5 asString equals: 'true'