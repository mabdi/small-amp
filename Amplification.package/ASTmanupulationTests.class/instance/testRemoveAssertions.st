tests
testRemoveAssertions
	| result |
	result := testMethods
		collect: [ :each | ASTHelper uniqueInstance removeAssertions: each ].
	self
		assert:
			(result
				allSatisfy: [ :src | 
					((GeneralHelper stripString: src)
						findString: 'self assert:' onlyLetters) == 0 ]).
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