as yet unclassified
testWithdraw_13_39
	| b tmp_vCcLLg0EgJ1 tmp_KWp1bNqfjR2 tmp_2zWgnRKA973 tmp_z62B6O4uK74 tmp_cSmEMvnlbJ1 tmp_YMM8KdSJhA2 tmp_ZKTjSKwMSe3 tmp_ALseuj5bQg4 tmp_ATYiyG8E1U5 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp_cSmEMvnlbJ1 := b balance = 0.
	self assert: tmp_cSmEMvnlbJ1 asString equals: 'true'.
	tmp_vCcLLg0EgJ1 := b deposit: -1152921504606846976.
	self assert: tmp_vCcLLg0EgJ1 balance equals:  -1152921504606846976.
	tmp_YMM8KdSJhA2 := tmp_vCcLLg0EgJ1 balance = -1152921504606846976.
	self assert: tmp_YMM8KdSJhA2 asString equals: 'true'.
	tmp_KWp1bNqfjR2 := b balance = -1152921504606846976.
	self assert: tmp_KWp1bNqfjR2 asString equals: 'true'.
	tmp_ZKTjSKwMSe3 := tmp_KWp1bNqfjR2 asString = 'true'.
	self assert: tmp_ZKTjSKwMSe3 asString equals: 'true'.
	tmp_2zWgnRKA973 := b withdraw: -1152921504606846976.
	self assert: tmp_2zWgnRKA973 balance equals: 0.
	tmp_ALseuj5bQg4 := tmp_2zWgnRKA973 balance = -1152921504606846976.
	self assert: tmp_ALseuj5bQg4 asString equals: 'false'.
	tmp_z62B6O4uK74 := b balance = 70.
	self assert: tmp_z62B6O4uK74 asString equals: 'false'.
	tmp_ATYiyG8E1U5 := tmp_z62B6O4uK74 asString = 'false'.
	self assert: tmp_ATYiyG8E1U5 asString equals: 'true'