testing
isMutationResult: mutatedSelector betterThan: parentSelector basedOn: analysis
	| pkilled mkilled |
	pkilled := (analysis particularResults
		select: [ :res | 
			res result failures
				anySatisfy: [ :meth | meth selector = parentSelector ] ])
		collect: [ :item | item mutant modifiedSource ].
	mkilled := (analysis particularResults
		select: [ :res | 
			res result failures
				anySatisfy: [ :meth | meth selector = mutatedSelector ] ])
		collect: [ :item | item mutant modifiedSource ].
	^ (pkilled allSatisfy: [ :item | mkilled includes: item ])
		and: [ mkilled anySatisfy: [ :item | (pkilled includes: item) not ] ]