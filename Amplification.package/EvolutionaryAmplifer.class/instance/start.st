accessing
start
	" Here is the main loop of program."

	| population |
	population := testMethods
		collect: [ :tcase | 
			TestMethodObject
				withClass: testClass
				method: tcase
				targets: targetClasses ].
	iterations
		timesRepeat: [ 
			population do: [ :tcase | self removeAssrtion: tcase ].
			population := (population
				collect: [ :tcase | self doMutation: tcase ]) flattened.
			population := population
				collect: [ :tcase | self assertionAmplify: tcase ].
			population := self doSelection: population ].
	^ self
		makeTestClass: (population collect: [ :tcase | tcase testMethod ])