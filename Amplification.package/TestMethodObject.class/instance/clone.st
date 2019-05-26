copying
clone
	| obj |
	obj := self class
		withClass: self testClass
		method: self testMethod
		targets: self testTargets.
	obj testMethodNoAssert: self testMethodNoAssert.
	obj testMethodMutated: self testMethodMutated.
	obj testMethodNewAssert: self testMethodNewAssert.
	^ obj