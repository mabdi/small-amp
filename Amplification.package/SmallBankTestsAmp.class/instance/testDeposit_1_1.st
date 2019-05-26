as yet unclassified
testDeposit_1_1
	| b tmp_HDvILltnMm1 tmp_WFQ78JAc8D2 tmp_7GSS2vIdJy3 tmp_wH9IfuKTSj4 tmp_mqLDItisc21 tmp_S8P0cLwodm2 tmp_1p3flNytI23 tmp_k6whigEPeF4 tmp_c5OCdYdRAS5 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp_mqLDItisc21 := b balance = 1.
	self assert: tmp_mqLDItisc21 asString equals: 'false'.
	tmp_HDvILltnMm1 := b deposit: 11.
	self assert: tmp_HDvILltnMm1 balance equals: 11.
	tmp_S8P0cLwodm2 := tmp_HDvILltnMm1 balance = 11.
	self assert: tmp_S8P0cLwodm2 asString equals: 'true'.
	tmp_WFQ78JAc8D2 := b balance = 11.
	self assert: tmp_WFQ78JAc8D2 asString equals: 'true'.
	tmp_1p3flNytI23 := tmp_WFQ78JAc8D2 asString = 'true'.
	self assert: tmp_1p3flNytI23 asString equals: 'true'.
	tmp_7GSS2vIdJy3 := b deposit: 100.
	self assert: tmp_7GSS2vIdJy3 balance equals: 111.
	tmp_k6whigEPeF4 := tmp_7GSS2vIdJy3 balance = 111.
	self assert: tmp_k6whigEPeF4 asString equals: 'true'.
	tmp_wH9IfuKTSj4 := b balance = 110.
	self assert: tmp_wH9IfuKTSj4 asString equals: 'false'.
	tmp_c5OCdYdRAS5 := tmp_wH9IfuKTSj4 asString = 'false'.
	self assert: tmp_c5OCdYdRAS5 asString equals: 'true'