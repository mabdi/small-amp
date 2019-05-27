as yet unclassified
testDeposit_1_1
	| b tmp_tG4BCLlH6j1 tmp_h3qfFgTt8T2 tmp_TKBQTg41iv3 tmp_iCNFq2sVnr4 tmp_sgI0A52OwO1 tmp_aqT3NX0odC2 tmp_nmZ071BLZ43 tmp_7EW8JDm6dJ4 tmp_swSQ78u1SC5 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp_sgI0A52OwO1 := b balance = 1.
	self assert: tmp_sgI0A52OwO1 asString equals: 'false'.
	tmp_tG4BCLlH6j1 := b deposit: 11.
	self assert: tmp_tG4BCLlH6j1 balance equals: 11.
	tmp_aqT3NX0odC2 := tmp_tG4BCLlH6j1 balance = 11.
	self assert: tmp_aqT3NX0odC2 asString equals: 'true'.
	tmp_h3qfFgTt8T2 := b balance = 11.
	self assert: tmp_h3qfFgTt8T2 asString equals: 'true'.
	tmp_nmZ071BLZ43 := tmp_h3qfFgTt8T2 asString = 'true'.
	self assert: tmp_nmZ071BLZ43 asString equals: 'true'.
	tmp_TKBQTg41iv3 := b deposit: 100.
	self assert: tmp_TKBQTg41iv3 balance equals: 111.
	tmp_7EW8JDm6dJ4 := tmp_TKBQTg41iv3 balance = 111.
	self assert: tmp_7EW8JDm6dJ4 asString equals: 'true'.
	tmp_iCNFq2sVnr4 := b balance = 110.
	self assert: tmp_iCNFq2sVnr4 asString equals: 'false'.
	tmp_swSQ78u1SC5 := tmp_iCNFq2sVnr4 asString = 'false'.
	self assert: tmp_swSQ78u1SC5 asString equals: 'true'