tests
testUnObject1
	| value temp data |
	data := 1 @ 2.
	temp := SerializerFactory serialize: data.
	value := SerializerFactory unserialize: temp.
	self
		assert: value asString
		equals:
			'a Dictionary(#x->a Dictionary(#class->SmallInteger #type->#primitive #value->''1'' ) #y->a Dictionary(#class->SmallInteger #type->#primitive #value->''2'' ) )'