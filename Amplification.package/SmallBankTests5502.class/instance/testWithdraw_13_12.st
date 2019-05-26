as yet unclassified
testWithdraw_13_12
	| b tmp_vCcLLg0EgJ1 tmp_KWp1bNqfjR2 tmp_2zWgnRKA973 tmp_z62B6O4uK74 tmp_5k3hWlps8x1 tmp_v9V7UwURKp2 tmp_6IlaLPCOdL3 tmp_sR7uzpUxtZ4 tmp_1eqKxGshF35 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp_5k3hWlps8x1 := b balance = 0.
	self assert: tmp_5k3hWlps8x1 asString equals: 'true'.
	tmp_vCcLLg0EgJ1 := b deposit: 1152921504606846975.
	self assert: tmp_vCcLLg0EgJ1 balance equals: 1152921504606846975.
	tmp_v9V7UwURKp2 := tmp_vCcLLg0EgJ1 balance = 1152921504606846975.
	self assert: tmp_v9V7UwURKp2 asString equals: 'true'.
	tmp_KWp1bNqfjR2 := b balance = 1152921504606846975.
	self assert: tmp_KWp1bNqfjR2 asString equals: 'true'.
	tmp_6IlaLPCOdL3 := tmp_KWp1bNqfjR2 asString = 'true'.
	self assert: tmp_6IlaLPCOdL3 asString equals: 'true'.
	tmp_2zWgnRKA973 := b withdraw: 30.
	self assert: tmp_2zWgnRKA973 balance equals: 1152921504606846945.
	tmp_sR7uzpUxtZ4 := tmp_2zWgnRKA973 balance = 1152921504606846975.
	self assert: tmp_sR7uzpUxtZ4 asString equals: 'false'.
	tmp_z62B6O4uK74 := b balance = 70.
	self assert: tmp_z62B6O4uK74 asString equals: 'false'.
	tmp_1eqKxGshF35 := tmp_z62B6O4uK74 asString = 'false'.
	self assert: tmp_1eqKxGshF35 asString equals: 'true'