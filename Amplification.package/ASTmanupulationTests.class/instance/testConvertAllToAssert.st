tests
testConvertAllToAssert
	| result |
	result := testMethods
		collect: [ :each | ASTHelper uniqueInstance convertAllToAssert: each ].
	self
		assert:
			(result
				allSatisfy: [ :src | 
					((GeneralHelper stripString: src) findString: 'self deny:' onlyLetters)
						== 0 ]).
	self
		assert:
			(result
				allSatisfy:
					[ :src | ((GeneralHelper stripString: src) findString: 'self should:' onlyLetters) == 0 ])