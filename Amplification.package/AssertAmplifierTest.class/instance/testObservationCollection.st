tests
testObservationCollection
	| aMethod aClass generatedClass anArrayTime aStringNoTime |
	aMethod := RBParser
		parseMethod:
			'testFoo
	| tmp1 tmp2 |
	tmp1 := someString size.
	someString := someString , ''0''.
	tmp2 := Array
		with: 1;
		with: 2'.
	aClass := FakeTestcase.
	instance insertObservers: aMethod.
	generatedClass := instance buildAxularyClass: aMethod basedOn: aClass.
	generatedClass suite run.
	anArrayTime := generatedClass observer memory
		collect: [ :item | item at: #time ].
	aStringNoTime := (generatedClass observer memory
		collect: [ :item | 
			item removeKey: #time.
			item ]) asString.
	generatedClass removeFromSystem.
	self assert: anArrayTime sorted equals: anArrayTime.
	self
		assert: aStringNoTime
		equals:
			'an OrderedCollection(a Dictionary(#class->SmallInteger #id->1 #name->#tmp1 #type->#primitive #value->''4'' ) a Dictionary(#class->ByteString #id->2 #name->#someString #type->#primitive #value->''abcd'' ) a Dictionary(#class->ByteString #id->3 #name->#someString #type->#primitive #value->''abcd0'' ) a Dictionary(#class->Array #id->5 #name->#tmp2 #type->#collection #value->an OrderedCollection(a Dictionary(#class->SmallInteger #type->#primitive #value->''2'' )) ))'