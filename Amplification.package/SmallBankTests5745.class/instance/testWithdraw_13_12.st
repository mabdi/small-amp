as yet unclassified
testWithdraw_13_12
	| b tmp_J21PlB8MBF1 tmp_ZXEtJFlzWQ2 tmp_CgQCCL3njG3 tmp_40KnAsUUOO4 tmp_CHCagHBjzG1 tmp_J0zcOFXVi52 tmp_nz0lW6MR3U3 tmp_NWrrsqRM3j4 tmp_ewjdWc9E9S5 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp_CHCagHBjzG1 := b balance = 0.
	self assert: tmp_CHCagHBjzG1 asString equals: 'true'.
	tmp_J21PlB8MBF1 := b deposit: 1152921504606846975.
	self assert: tmp_J21PlB8MBF1 balance equals: 1152921504606846975.
	tmp_J0zcOFXVi52 := tmp_J21PlB8MBF1 balance = 1152921504606846975.
	self assert: tmp_J0zcOFXVi52 asString equals: 'true'.
	tmp_ZXEtJFlzWQ2 := b balance = 1152921504606846975.
	self assert: tmp_ZXEtJFlzWQ2 asString equals: 'true'.
	tmp_nz0lW6MR3U3 := tmp_ZXEtJFlzWQ2 asString = 'true'.
	self assert: tmp_nz0lW6MR3U3 asString equals: 'true'.
	tmp_CgQCCL3njG3 := b withdraw: 30.
	self assert: tmp_CgQCCL3njG3 balance equals: 1152921504606846945.
	tmp_NWrrsqRM3j4 := tmp_CgQCCL3njG3 balance = 1152921504606846975.
	self assert: tmp_NWrrsqRM3j4 asString equals: 'false'.
	tmp_40KnAsUUOO4 := b balance = 70.
	self assert: tmp_40KnAsUUOO4 asString equals: 'false'.
	tmp_ewjdWc9E9S5 := tmp_40KnAsUUOO4 asString = 'false'.
	self assert: tmp_ewjdWc9E9S5 asString equals: 'true'