running
assertPattern
	^ '(``@actual difference: ``@expected) isEmpty and: [(``@expected
		difference: (``@actual intersection: ``@expected)) isEmpty]'