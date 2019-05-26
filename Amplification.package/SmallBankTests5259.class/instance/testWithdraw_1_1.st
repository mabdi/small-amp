as yet unclassified
testWithdraw_1_1
	| b tmp_XFD0cgCt6s1 tmp_8BdRtXNFph2 tmp_ihG8JyTHOH3 tmp_GPudTDM1hi4 tmp_bGLRr4nbeE1 tmp_1MM2JDzuxk2 tmp_Ku4azib5qO3 tmp_jNhEOqXmGS4 tmp_RYTbnaPZ5D5 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp_XFD0cgCt6s1 := b balance = 1.
	self assert: tmp_XFD0cgCt6s1 asString equals: 'false'.
	tmp_XFD0cgCt6s1 := b deposit: 101.
	tmp_8BdRtXNFph2 := tmp_XFD0cgCt6s1 balance = 101.
	self assert: tmp_8BdRtXNFph2 asString equals: 'true'.
	tmp_8BdRtXNFph2 := b balance = 101.
	tmp_ihG8JyTHOH3 := tmp_8BdRtXNFph2 asString = 'true'.
	self assert: tmp_ihG8JyTHOH3 asString equals: 'true'.
	tmp_ihG8JyTHOH3 := b withdraw: 30.
	tmp_GPudTDM1hi4 := tmp_ihG8JyTHOH3 balance = 71.
	self assert: tmp_GPudTDM1hi4 asString equals: 'true'.
	tmp_GPudTDM1hi4 := b balance = 70.
	tmp_bGLRr4nbeE1 := tmp_GPudTDM1hi4 asString = 'false'.
	self assert: tmp_bGLRr4nbeE1 asString equals: 'true'