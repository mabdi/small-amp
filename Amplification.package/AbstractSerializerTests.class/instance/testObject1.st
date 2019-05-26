tests
testObject1
	| value |
	value := AbstractSerializer serialize: 1 @ 2.
	self assert: (value at: #type) equals: #object.
	self assert: (value at: #class) equals: Point.
	self
		assert: (value at: #value) asString
		equals:
			'a Dictionary(#x->a Dictionary(#class->SmallInteger #type->#string #value->''1'' ) #y->a Dictionary(#class->SmallInteger #type->#string #value->''2'' ) )'