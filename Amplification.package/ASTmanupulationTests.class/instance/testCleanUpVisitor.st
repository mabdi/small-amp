tests
testCleanUpVisitor
	| s r |
	s := 'testWithdraw_1_1
	| b tmp_ZISDO00DGz1 tmp_9nbUP3optD2 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp_ZISDO00DGz1 := b deposit: 102.
	self assert: tmp_ZISDO00DGz1 balance equals: 102.
	tmp_9nbUP3optD2 := b withdraw: 30.
	self assert: b balance equals: 72'.
	r := ASTHelper new cleanUp: s.
	self assert: r equals: 'testWithdraw_1_1
	| b tmp_ZISDO00DGz1 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp_ZISDO00DGz1 := b deposit: 102.
	self assert: tmp_ZISDO00DGz1 balance equals: 102.
	b withdraw: 30.
	self assert: b balance equals: 72'