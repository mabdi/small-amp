as yet unclassified
testDeposit_1_1
	| b tmp_Je8h6gTKFb1 tmp_403kVq78hU2 tmp_vkqEOHdEZE3 tmp_VVvXXp5ENb4 tmp_mMt5JRAzLq1 tmp_z218INA9tU2 tmp_eLPvQruwF93 tmp_z5SXWWlWjz4 tmp_nyEKnmVToz5 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp_mMt5JRAzLq1 := b balance = 1.
	self assert: tmp_mMt5JRAzLq1 asString equals: 'false'.
	tmp_Je8h6gTKFb1 := b deposit: 11.
	self assert: tmp_Je8h6gTKFb1 balance equals: 11.
	tmp_z218INA9tU2 := tmp_Je8h6gTKFb1 balance = 11.
	self assert: tmp_z218INA9tU2 asString equals: 'true'.
	tmp_403kVq78hU2 := b balance = 11.
	self assert: tmp_403kVq78hU2 asString equals: 'true'.
	tmp_eLPvQruwF93 := tmp_403kVq78hU2 asString = 'true'.
	self assert: tmp_eLPvQruwF93 asString equals: 'true'.
	tmp_vkqEOHdEZE3 := b deposit: 100.
	self assert: tmp_vkqEOHdEZE3 balance equals: 111.
	tmp_z5SXWWlWjz4 := tmp_vkqEOHdEZE3 balance = 111.
	self assert: tmp_z5SXWWlWjz4 asString equals: 'true'.
	tmp_VVvXXp5ENb4 := b balance = 110.
	self assert: tmp_VVvXXp5ENb4 asString equals: 'false'.
	tmp_nyEKnmVToz5 := tmp_VVvXXp5ENb4 asString = 'false'.
	self assert: tmp_nyEKnmVToz5 asString equals: 'true'