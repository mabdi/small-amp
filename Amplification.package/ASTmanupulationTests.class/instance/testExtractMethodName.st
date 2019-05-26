tests
testExtractMethodName
	{UUID.
	UUIDGenerator.
	OrderedCollection.
	FakeTestcase}
		do: [ :class | 
			class methods
				do: [ :method | 
					self
						assert: (method selector asString)
						equals:
							(ASTHelper uniqueInstance extractMethodName: method sourceCode)
								 ] ]