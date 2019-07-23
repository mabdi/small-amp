actions
doSelection: aPopulation
	| selectedTests |
	selectedTests := self selector doSelect: aPopulation.
	^ selectedTests
		collect: [ :obj | 
			TestMethodObject
				withClass: obj testClass
				method: (self astHelper cleanUp: obj testMethodModified)
				targets: obj testTargets ]