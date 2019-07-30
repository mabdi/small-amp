tests
testAssertionGenerationComplex
	| aMethod aClass generatedClass observer |
	aMethod := RBParser
		parseMethod:
			'testFoo
	| array |
	array := OrderedCollection with: 1@1.
	array add: (10@10).
	array add: (100@100).
	array at: 2 put: (23@23).
	array removeAt:3
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
	| array tmp1 tmp2 tmp3 tmp4 |
	array := OrderedCollection with: 1 @ 1.
	self assert: array size equals: 1.
	tmp1 := array add: 10 @ 10.
	self assert: array size equals: 2.
	self assert: tmp1 x equals: 10.
	self assert: tmp1 y equals: 10.
	tmp2 := array add: 100 @ 100.
	self assert: array size equals: 3.
	self assert: tmp2 x equals: 100.
	self assert: tmp2 y equals: 100.
	tmp3 := array at: 2 put: 23 @ 23.
	self assert: array size equals: 3.
	self assert: tmp3 x equals: 23.
	self assert: tmp3 y equals: 23.
	tmp4 := array removeAt: 3.
	self assert: array size equals: 2.
	self assert: tmp4 x equals: 100.
	self assert: tmp4 y equals: 100'