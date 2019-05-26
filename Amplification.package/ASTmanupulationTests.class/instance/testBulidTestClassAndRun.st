tests
testBulidTestClassAndRun
	| result methods |
	methods := testMethods
		collect: [ :atestMethod | 
			(MuTalkMutationOperator new mutate: atestMethod) ].
	methods := methods flattened.
	result := ASTHelper uniqueInstance
		buildAnTestClassWith: methods
		using: FakeTestcase.
	self
		deny: (result methods detect: [ :mtd | mtd selector = #setUp ]) isNil.
	self assert: result methods size - 1 equals: methods size