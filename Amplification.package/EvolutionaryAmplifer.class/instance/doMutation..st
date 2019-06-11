actions
doMutation: tcase
	| newcodes |
	newcodes := PopulationCollection new.
	self mutationOperators
		do: [ :op | newcodes addAll: (op mutate: tcase testMethodNoAssert) ].
	newcodes := newcodes
		collect: [ :cod | tcase clone testMethodMutated: cod ].
	^ newcodes