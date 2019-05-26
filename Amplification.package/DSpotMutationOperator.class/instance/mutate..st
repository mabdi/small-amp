removing
mutate: aMethod
	| mutants |
	mutants := DSpotASTMutationRewriter new doYourJob: aMethod.
	^ self renameMutations: mutants