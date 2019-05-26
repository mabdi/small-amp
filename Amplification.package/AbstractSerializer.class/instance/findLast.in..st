private
findLast: anObservation in: aMemory
	| idx |
	idx := aMemory indexOf: anObservation.
	^ (aMemory first: idx) reverse
		detect:[ :a | 
			(a at: #name) = (anObservation at: #name)
				and: [ (a at: #id) < (anObservation at: #id) ] ]
			ifNone:[^ nil]