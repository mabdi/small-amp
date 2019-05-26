running
setUp
	"Hooks that subclasses may override to define the fixture of test."

	super setUp.
	testMethods := (FakeTestcase methods
		select: [ :each | each selector beginsWith: 'test' ]).