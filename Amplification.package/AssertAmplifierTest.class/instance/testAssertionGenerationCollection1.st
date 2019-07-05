tests
testAssertionGenerationCollection1
	| aMethod aClass generatedClass observer |
	aMethod := RBParser
		parseMethod:
			'testFoo
	| array |
	array := OrderedCollection new.
	array add: someVariable
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
	array := OrderedCollection new.
	self assert: array size equals: 0.
	tmp1 := array add: someVariable.
	self assert: tmp1 equals: 1.
	self assert: (array at: 1) equals: 1.
	self assert: array size equals: 1'