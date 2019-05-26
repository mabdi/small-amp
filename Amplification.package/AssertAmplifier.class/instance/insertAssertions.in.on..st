as yet unclassified
insertAssertions: asserts in: aMethod on: observation
	aMethod body statements
		detect: [ :item | 
			((item isKindOf: RBMessageNode)
				and: [ item selector = #observe:name:id: ])
				and: [ (item arguments at: 3) value = (observation at: #id) ] ]
		ifFound: [ :item | 
			| idx |
			idx := aMethod body statements indexOf: item.
			
			asserts
				do: [ :assert | aMethod body statements add: assert afterIndex: idx ].
			aMethod body statements remove: item ]