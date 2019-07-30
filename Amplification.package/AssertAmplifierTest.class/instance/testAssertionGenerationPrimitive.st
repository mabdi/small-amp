tests
testAssertionGenerationPrimitive
	| aMethod aClass generatedClass observer |
	aMethod := RBParser
		parseMethod:
			'testFoo
	| tmp1|
	tmp1 := 1.
	someVariable := someVariable + tmp1.
	tmp1 := someVariable - 1.
	someString := someString, ''111'''.
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
	| tmp1 |
	tmp1 := 1.
	someVariable := someVariable + tmp1.
	self assert: someVariable equals: 2.
	tmp1 := someVariable - 1.
	self assert: someVariable equals: 2.
	self assert: tmp1 equals: 1.
	someString := someString , ''111''.
	self assert: someString equals: ''abcd111'''