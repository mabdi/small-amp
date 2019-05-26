as yet unclassified
testWithdraw_13_39
	| b tmp_i4zNvD1mVA1 tmp_3TMFTpQDQ52 tmp_ZxNilMYgMT3 tmp_rdE6viuAJE4 tmp_FEMJ5JeQRD1 tmp_tWYjU5QtUo2 tmp_B3IR4tnpaU3 tmp_zIeqJgDeBQ4 tmp_BbQ9jJnqv35 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp_FEMJ5JeQRD1 := b balance = 0.
	self assert: tmp_FEMJ5JeQRD1 asString equals: 'true'.
	tmp_i4zNvD1mVA1 := b deposit: -1152921504606846976.
	self assert: tmp_i4zNvD1mVA1 balance equals:  -1152921504606846976.
	tmp_tWYjU5QtUo2 := tmp_i4zNvD1mVA1 balance = -1152921504606846976.
	self assert: tmp_tWYjU5QtUo2 asString equals: 'true'.
	tmp_3TMFTpQDQ52 := b balance = -1152921504606846976.
	self assert: tmp_3TMFTpQDQ52 asString equals: 'true'.
	tmp_B3IR4tnpaU3 := tmp_3TMFTpQDQ52 asString = 'true'.
	self assert: tmp_B3IR4tnpaU3 asString equals: 'true'.
	tmp_ZxNilMYgMT3 := b withdraw: -1152921504606846976.
	self assert: tmp_ZxNilMYgMT3 balance equals: 0.
	tmp_zIeqJgDeBQ4 := tmp_ZxNilMYgMT3 balance = -1152921504606846976.
	self assert: tmp_zIeqJgDeBQ4 asString equals: 'false'.
	tmp_rdE6viuAJE4 := b balance = 70.
	self assert: tmp_rdE6viuAJE4 asString equals: 'false'.
	tmp_BbQ9jJnqv35 := tmp_rdE6viuAJE4 asString = 'false'.
	self assert: tmp_BbQ9jJnqv35 asString equals: 'true'