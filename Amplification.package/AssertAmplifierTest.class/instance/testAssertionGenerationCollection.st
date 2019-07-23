tests
testAssertionGenerationCollection
	| aMethod aClass generatedClass observer |
	aMethod := RBParser
		parseMethod:
			'testFoo
	| array |
	array := OrderedCollection with: 56.
	array at: 1 put: someVariable.
	array add: someVariable + 10.
	array addAll: { 12 . 13 }.
	array add: someVariable * 4.
	array remove: someVariable.
	array at: 2 put: 3000.
	array removeAt: 2.
	array removeAll
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
	| array tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7 tmp8 |
	array := OrderedCollection with: 56.
	self assert: array size equals: 1.
	tmp1 := array at: 1 put: someVariable.
	self deny: (array at: 1) equals: 56.
	self assert: (array at: 1) equals: 1.
	self assert: tmp1 equals: 1.
	tmp2 := array add: someVariable + 10.
	self assert: (array at: 2) equals: 11.
	self assert: array size equals: 2.
	self assert: tmp2 equals: 11.
	tmp3 := array addAll: {12 . 13}.
	self assert: array size equals: 4.
	self assert: tmp3 size equals: 2.
	tmp4 := array add: someVariable * 4.
	self assert: (array at: 5) equals: 4.
	self assert: array size equals: 5.
	self assert: tmp4 equals: 4.
	tmp5 := array remove: someVariable.
	self deny: (array at: 1) equals: 1.
	self assert: array size equals: 4.
	self assert: tmp5 equals: 1.
	tmp6 := array at: 2 put: 3000.
	self deny: (array at: 2) equals: 12.
	self assert: (array at: 2) equals: 3000.
	self assert: tmp6 equals: 3000.
	tmp7 := array removeAt: 2.
	self deny: (array at: 2) equals: 3000.
	self assert: array size equals: 3.
	self assert: tmp7 equals: 3000.
	tmp8 := array removeAll.
	self assert: array size equals: 0'