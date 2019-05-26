as yet unclassified
testWithdraw_13_1
	| b tmp_i4zNvD1mVA1 tmp_3TMFTpQDQ52 tmp_ZxNilMYgMT3 tmp_rdE6viuAJE4 tmp_tsOpgn6Am41 tmp_jgDuVyRgRd2 tmp_cavhVNYU9Y3 tmp_kdmnQBDktk4 tmp_N5vLfESa7F5 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp_tsOpgn6Am41 := b balance = 1.
	self assert: tmp_tsOpgn6Am41 asString equals: 'false'.
	tmp_i4zNvD1mVA1 := b deposit: -1152921504606846976.
	self assert: tmp_i4zNvD1mVA1 balance equals:  -1152921504606846976.
	tmp_jgDuVyRgRd2 := tmp_i4zNvD1mVA1 balance = -1152921504606846976.
	self assert: tmp_jgDuVyRgRd2 asString equals: 'true'.
	tmp_3TMFTpQDQ52 := b balance = -1152921504606846976.
	self assert: tmp_3TMFTpQDQ52 asString equals: 'true'.
	tmp_cavhVNYU9Y3 := tmp_3TMFTpQDQ52 asString = 'true'.
	self assert: tmp_cavhVNYU9Y3 asString equals: 'true'.
	tmp_ZxNilMYgMT3 := b withdraw: 30.
	self assert: tmp_ZxNilMYgMT3 balance equals:  -1152921504606846976.
	tmp_kdmnQBDktk4 := tmp_ZxNilMYgMT3 balance = -1152921504606846976.
	self assert: tmp_kdmnQBDktk4 asString equals: 'true'.
	tmp_rdE6viuAJE4 := b balance = 70.
	self assert: tmp_rdE6viuAJE4 asString equals: 'false'.
	tmp_N5vLfESa7F5 := tmp_rdE6viuAJE4 asString = 'false'.
	self assert: tmp_N5vLfESa7F5 asString equals: 'true'