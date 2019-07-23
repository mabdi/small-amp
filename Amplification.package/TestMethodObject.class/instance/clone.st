copying
clone
	| obj |
	obj := self class
		withClass: self testClass
		method: self testMethod
		targets: self testTargets.
	obj testMethodModified: self testMethodModified.
	^ obj