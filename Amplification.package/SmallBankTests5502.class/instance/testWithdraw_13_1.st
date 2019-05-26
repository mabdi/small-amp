as yet unclassified
testWithdraw_13_1
	| b tmp_vCcLLg0EgJ1 tmp_KWp1bNqfjR2 tmp_2zWgnRKA973 tmp_z62B6O4uK74 tmp_YYxHxOPSE81 tmp_03PQXMNRBT2 tmp_Q8GWBrTlYP3 tmp_LmZEgqJT3k4 tmp_dmH7cAlqHc5 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp_YYxHxOPSE81 := b balance = 1.
	self assert: tmp_YYxHxOPSE81 asString equals: 'false'.
	tmp_vCcLLg0EgJ1 := b deposit: -1152921504606846976.
	self assert: tmp_vCcLLg0EgJ1 balance equals:  -1152921504606846976.
	tmp_03PQXMNRBT2 := tmp_vCcLLg0EgJ1 balance = -1152921504606846976.
	self assert: tmp_03PQXMNRBT2 asString equals: 'true'.
	tmp_KWp1bNqfjR2 := b balance = -1152921504606846976.
	self assert: tmp_KWp1bNqfjR2 asString equals: 'true'.
	tmp_Q8GWBrTlYP3 := tmp_KWp1bNqfjR2 asString = 'true'.
	self assert: tmp_Q8GWBrTlYP3 asString equals: 'true'.
	tmp_2zWgnRKA973 := b withdraw: 30.
	self assert: tmp_2zWgnRKA973 balance equals:  -1152921504606846976.
	tmp_LmZEgqJT3k4 := tmp_2zWgnRKA973 balance = -1152921504606846976.
	self assert: tmp_LmZEgqJT3k4 asString equals: 'true'.
	tmp_z62B6O4uK74 := b balance = 70.
	self assert: tmp_z62B6O4uK74 asString equals: 'false'.
	tmp_dmH7cAlqHc5 := tmp_z62B6O4uK74 asString = 'false'.
	self assert: tmp_dmH7cAlqHc5 asString equals: 'true'