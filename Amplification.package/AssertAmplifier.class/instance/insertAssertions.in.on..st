as yet unclassified
insertAssertions: asserts in: aMethod on: observation
	aMethod body statements
		detect: [ :item | self findObservationPoint: item id: (observation at: #id) ]
		ifFound: [ :item | 
			| idx |
			idx := aMethod body statements indexOf: item.
			asserts
				do: [ :assert | aMethod body statements add: assert afterIndex: idx ].
			aMethod body statements remove: item ]