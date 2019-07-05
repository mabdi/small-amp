tests
testAssertionGenerationObject
	| aMethod aClass generatedClass observer |
	aMethod := RBParser
		parseMethod:
			'testFoo
	| node node1 |
	node := 3@1.
	node := node + (10@10).
	node1 := node dist: (0@1)
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
	| node node1 |
	node := 3 @ 1.
	self assert: node x equals: 3.
	self assert: node y equals: 1.
	node := node + (10 @ 10).
	self assert: node x equals: 13.
	self assert: node y equals: 11.
	node1 := node dist: 0 @ 1.
	self assert: node1 equals: 16.401219466856727'