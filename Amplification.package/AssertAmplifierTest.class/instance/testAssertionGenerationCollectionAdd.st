tests
testAssertionGenerationCollectionAdd
	| aMethod aClass generatedClass observer |
	aMethod := RBParser
		parseMethod:
			'testFoo
	| array |
	array := OrderedCollection with:10 with:20 with:30.
	array add: 40.
	array add: 11 after: 10.
	array add: 21 afterIndex: 3
	'.
	aClass := FakeTestcase.
	instance insertObservers: aMethod.
	generatedClass := instance buildAxularyClass: aMethod basedOn: aClass.
	generatedClass suite run.
	observer := generatedClass observer.
	generatedClass removeFromSystem.
	instance insertAsserts: aMethod using: observer.
	self
		assert: (GeneralHelper renameTempVars: aMethod formattedCode)
		equals:
			'testFoo
	| array tmp1 tmp2 tmp3 |
	array := OrderedCollection with: 10 with: 20 with: 30.
	self assert: array size equals: 3.
	tmp1 := array add: 40.
	self assert: array size equals: 4.
	self assert: tmp1 equals: 40.
	tmp2 := array add: 11 after: 10.
	self assert: array size equals: 5.
	self assert: tmp2 equals: 11.
	tmp3 := array add: 21 afterIndex: 3.
	self assert: array size equals: 6.
	self assert: tmp3 equals: 21'