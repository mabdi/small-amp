as yet unclassified
testDeposit_1_1
	| b tmp_nT9AvYHWbE1 tmp_7N88IQZpvR2 tmp_zIUN6Vdj4y3 tmp_IglTGBNUBC4 tmp_jv2J32oTGg1 tmp_g9N3LGCzfD2 tmp_ZhEqb736t63 tmp_fKu05T1RPj4 tmp_Uv4UkYPtio5 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp_jv2J32oTGg1 := b balance = 1.
	self assert: tmp_jv2J32oTGg1 asString equals: 'false'.
	tmp_nT9AvYHWbE1 := b deposit: 11.
	self assert: tmp_nT9AvYHWbE1 balance equals: 11.
	tmp_g9N3LGCzfD2 := tmp_nT9AvYHWbE1 balance = 11.
	self assert: tmp_g9N3LGCzfD2 asString equals: 'true'.
	tmp_7N88IQZpvR2 := b balance = 11.
	self assert: tmp_7N88IQZpvR2 asString equals: 'true'.
	tmp_ZhEqb736t63 := tmp_7N88IQZpvR2 asString = 'true'.
	self assert: tmp_ZhEqb736t63 asString equals: 'true'.
	tmp_zIUN6Vdj4y3 := b deposit: 100.
	self assert: tmp_zIUN6Vdj4y3 balance equals: 111.
	tmp_fKu05T1RPj4 := tmp_zIUN6Vdj4y3 balance = 111.
	self assert: tmp_fKu05T1RPj4 asString equals: 'true'.
	tmp_IglTGBNUBC4 := b balance = 110.
	self assert: tmp_IglTGBNUBC4 asString equals: 'false'.
	tmp_Uv4UkYPtio5 := tmp_IglTGBNUBC4 asString = 'false'.
	self assert: tmp_Uv4UkYPtio5 asString equals: 'true'