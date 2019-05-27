tests
testArray2D
	| value matrix23 |
	matrix23 := Array2D rows: 3 columns: 2.
	matrix23 at: 1 at: 1 put: 11.
	matrix23 at: 1 at: 2 put: 21.
	matrix23 at: 2 at: 1 put: 12.
	matrix23 at: 2 at: 2 put: 22.
	matrix23 at: 3 at: 1 put: 13.
	matrix23 at: 3 at: 2 put: 23.
	value := AbstractSerializer serialize: matrix23.
	self assert: (value at: #type) equals: #collection.
	self assert: (value at: #class) equals: Array2D.
	self assert: (value at: #value) size equals: 6.
	self assert: (((value at: #value) at: 3) at: #value) equals: '12'.
	self
		assert: (((value at: #value) at: 3) at: #class)
		equals: SmallInteger.
	self
		assert: (value at: #value) asString
		equals:
			'an OrderedCollection(a Dictionary(#class->SmallInteger #type->#string #value->''11'' ) a Dictionary(#class->SmallInteger #type->#string #value->''21'' ) a Dictionary(#class->SmallInteger #type->#string #value->''12'' ) a Dictionary(#class->SmallInteger #type->#string #value->''22'' ) a Dictionary(#class->SmallInteger #type->#string #value->''13'' ) a Dictionary(#class->SmallInteger #type->#string #value->''23'' ))'