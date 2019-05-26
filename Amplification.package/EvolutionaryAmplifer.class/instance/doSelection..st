actions
doSelection: aPopulation
	| selectedTests |
	selectedTests := self selector doSelect: aPopulation.
	^ selectedTests
		collect: [ :obj | 
			TestMethodObject
				withClass: obj testClass
				method: obj testMethodNewAssert
				targets: obj testTargets ]