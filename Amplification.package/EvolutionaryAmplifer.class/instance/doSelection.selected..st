actions
doSelection: aPopulation selected: aPopulationAll
	| selectedTests |
	aPopulation ifEmpty: [ ^ aPopulation  ].
	selectedTests := OrderedCollection new.
	self selectors
		do: [ :sel | 
			selectedTests
				addAll: (sel doSelect: aPopulation selected: aPopulationAll) ].
	^ selectedTests
		collect: [ :obj | 
			TestMethodObject
				withClass: obj testClass
				method: (self astHelper cleanUp: obj testMethodModified)
				targets: obj testTargets ]