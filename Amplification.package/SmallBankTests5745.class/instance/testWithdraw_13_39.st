as yet unclassified
testWithdraw_13_39
	| b tmp_J21PlB8MBF1 tmp_ZXEtJFlzWQ2 tmp_CgQCCL3njG3 tmp_40KnAsUUOO4 tmp_9i86DCkqAw1 tmp_FZ7BTR7sUU2 tmp_S3Ue8D03tG3 tmp_Cv6Md4INk04 tmp_SDyzcKXYeB5 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp_9i86DCkqAw1 := b balance = 0.
	self assert: tmp_9i86DCkqAw1 asString equals: 'true'.
	tmp_J21PlB8MBF1 := b deposit: -1152921504606846976.
	self assert: tmp_J21PlB8MBF1 balance equals:  -1152921504606846976.
	tmp_FZ7BTR7sUU2 := tmp_J21PlB8MBF1 balance = -1152921504606846976.
	self assert: tmp_FZ7BTR7sUU2 asString equals: 'true'.
	tmp_ZXEtJFlzWQ2 := b balance = -1152921504606846976.
	self assert: tmp_ZXEtJFlzWQ2 asString equals: 'true'.
	tmp_S3Ue8D03tG3 := tmp_ZXEtJFlzWQ2 asString = 'true'.
	self assert: tmp_S3Ue8D03tG3 asString equals: 'true'.
	tmp_CgQCCL3njG3 := b withdraw: -1152921504606846976.
	self assert: tmp_CgQCCL3njG3 balance equals: 0.
	tmp_Cv6Md4INk04 := tmp_CgQCCL3njG3 balance = -1152921504606846976.
	self assert: tmp_Cv6Md4INk04 asString equals: 'false'.
	tmp_40KnAsUUOO4 := b balance = 70.
	self assert: tmp_40KnAsUUOO4 asString equals: 'false'.
	tmp_SDyzcKXYeB5 := tmp_40KnAsUUOO4 asString = 'false'.
	self assert: tmp_SDyzcKXYeB5 asString equals: 'true'