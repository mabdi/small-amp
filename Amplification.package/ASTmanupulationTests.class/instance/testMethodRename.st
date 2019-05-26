tests
testMethodRename
	{UUID.
	UUIDGenerator.
	OrderedCollection.
	FakeTestcase}
		do: [ :class | 
			(class methods
				select: [ :mtd | (mtd selector asString at: 1) isLetter ])
				do: [ :method | 
					{'1' . 'new' . '_old'}
						do: [ :post | 
							self
								assert: ((method selector asString splitOn: $:) at: 1) , post
								equals:
									(ASTHelper uniqueInstance
										extractMethodName:
											(((ASTHelper uniqueInstance
												renameMethodName: method sourceCode
												append: post)selector asString splitOn: $:)at: 1)) ] ] ]