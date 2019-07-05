private
findLastInMemory: aMemory
	| idx |
	idx := aMemory indexOf: dictionary.
	^ (aMemory first: idx) reverse
		detect: [ :a | 
			(a at: #name) = (dictionary  at: #name)
				and: [ (a at: #id) < (dictionary at: #id) ] ]
		ifNone: [ ^ nil ]