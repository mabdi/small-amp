tests
testAssertionGenerationRedundant
	| aMethod aClass generatedClass observer |
	aMethod := RBParser
		parseMethod:
			'testFoo
	| b |
	b := SmallBank new.
	b deposit: 100.
	'.
	aClass := SmallBankTest .
	instance insertObservers: aMethod.
	generatedClass := instance buildAxularyClass: aMethod basedOn: aClass.
	generatedClass suite run.
	observer := generatedClass observer.
	"generatedClass removeFromSystem."
	instance insertAsserts: aMethod using: observer.
	self
		assert: (GeneralHelper renameTempVars: aMethod formattedCode)
		equals:
			'testFoo
	| b tmp1 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp1 := b deposit: 100.
	self assert: b balance equals: 100'