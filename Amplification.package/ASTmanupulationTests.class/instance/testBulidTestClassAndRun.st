tests
testBulidTestClassAndRun
	| result methods |
	"methods := testMethods
		collect:
			[ :atestMethod | DSpotMutationOperator new mutate: atestMethod sourceCode ].
	methods := methods flattened."
	methods := testMethods collect: [:atestMethod | atestMethod sourceCode].
	result := ASTHelper uniqueInstance
		buildAnTestClassWith: methods
		using: FakeTestcase.
	self
		deny: (result methods detect: [ :mtd | mtd selector = #setUp ]) isNil.
	self assert: result methods size - 1 equals: methods size.
	result removeFromSystem