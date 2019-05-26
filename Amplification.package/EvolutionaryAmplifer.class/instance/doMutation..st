actions
doMutation: tcase
	| newcodes |
	newcodes := OrderedCollection new.
	newcodes
		addAll:
			(self mutationOperators
				collect: [ :op | op mutate: tcase testMethodNoAssert ]) flattened.
	newcodes := newcodes
		collect: [ :cod | tcase clone testMethodMutated: cod ].
	^ newcodes