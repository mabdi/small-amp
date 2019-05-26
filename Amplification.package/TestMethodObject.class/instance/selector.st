accessing
selector
	^ selector ifNil: [ selector := ASTHelper uniqueInstance extractMethodName: testMethodNewAssert ]