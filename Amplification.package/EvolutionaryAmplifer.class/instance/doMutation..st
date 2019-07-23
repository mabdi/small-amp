actions
doMutation: tcase
	| newcodes |
	newcodes := PopulationCollection new.
	self mutationOperators
		do: [ :op | newcodes addAll: (op mutate: tcase testMethodModified) ].
	newcodes := newcodes
		collect: [ :cod | tcase clone testMethodModified: cod ].
	^ newcodes