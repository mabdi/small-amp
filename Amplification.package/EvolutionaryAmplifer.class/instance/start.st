accessing
start
	" Here is the main loop of program."

	| population |
	population := PopulationCollection
		setUpWith:
			(testMethods
				collect: [ :tcase | 
					TestMethodObject
						withClass: testClass
						method: tcase
						targets: targetClasses ]).
	(1 to: iterations)
		do: [ :gen | population
				do: [ :tcase | self removeAssrtion: tcase ]
				displayingProgress: 'Removing assertions'.
			population := (population
				collect: [ :tcase | self doMutation: tcase ]
				displayingProgress: 'Mutating test cases') flattened.
			population := population
				collect: [ :tcase | self assertionAmplify: tcase ] displayingProgress: 'Assert amplifying'.
			population := self doSelection: population ]
		displayingProgress: 'Main loop'.
	^ self
		makeTestClass: (population collect: [ :tcase | tcase testMethod ])