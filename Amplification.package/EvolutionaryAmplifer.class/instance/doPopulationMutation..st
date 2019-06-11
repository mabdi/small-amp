as yet unclassified
doPopulationMutation: aPopulation
	| newcodes |
	newcodes := PopulationCollection new.
	aPopulation do: [ :tcase | newcodes
		addAll: (self doMutation: tcase) ] displayingProgress: 'Mutating test cases'.
	
	
	^ newcodes