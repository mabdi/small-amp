tests
testAssertionGenerationCollectionSize
	| aMethod aClass generatedClass observer |
	aMethod := RBParser
		parseMethod:
			'testFoo
	| array |
	array := OrderedCollection with:10 with:20 with:30.
	array add: 40.
	array at: 1 put: 100.
	array remove: 20
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
	tmp2 := array at: 1 put: 100.
	self assert: array size equals: 4.
	self assert: tmp2 equals: 100.
	tmp3 := array remove: 20.
	self assert: array size equals: 3.
	self assert: tmp3 equals: 20'