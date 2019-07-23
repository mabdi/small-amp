accessing
start
	" Here is the main loop of program."

	| population resultPeople |
	EvalLog instanceReset.
	population := PopulationCollection
		setUpWith:
			(testMethods
				collect: [ :tcase | 
					TestMethodObject
						withClass: testClass
						method: tcase
						targets: targetClasses ]).
	resultPeople := population clone.
	(1 to: iterations)
		do: [ :gen | 
			EvalLog newGeneration.
			EvalLog tickAt: #time_all.
			EvalLog tickAt: #input_amp.
			population
				do: [ :tcase | self removeAssrtion: tcase ]
				displayingProgress: 'Removing assertions'.
			population := self doPopulationMutation: population.
			EvalLog tickAt: #input_amp.
			EvalLog tickAt: #assert_amp.
			population := population
				collect: [ :tcase | self assertionAmplify: tcase ]
				displayingProgress: 'Assert amplifying'.
			EvalLog tickAt: #assert_amp.
			EvalLog tickAt: #selection.
			population := self doSelection: population.
			resultPeople addAll: population.
			EvalLog tickAt: #selection.
			EvalLog tickAt: #time_all ]
		displayingProgress: 'Main loop'.
	^ self
		makeTestClass: (resultPeople collect: [ :tcase | tcase testMethod ])