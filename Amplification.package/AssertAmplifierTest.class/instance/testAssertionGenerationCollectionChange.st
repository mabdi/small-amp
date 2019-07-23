tests
testAssertionGenerationCollectionChange
	| aMethod aClass generatedClass observer |
	aMethod := RBParser
		parseMethod:
			'testFoo
	| array |
	array := OrderedCollection with:10 with:20 with:30.
	array at: 2 put: 2000
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
	| array tmp1 |
	array := OrderedCollection with: 10 with: 20 with: 30.
	self assert: array size equals: 3.
	tmp1 := array at: 2 put: 2000.
	self deny: (array at: 2) equals: 20.
	self assert: (array at: 2) equals: 2000.
	self assert: tmp1 equals: 2000'