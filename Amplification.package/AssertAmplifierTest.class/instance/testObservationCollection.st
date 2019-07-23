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
		with: 1
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
			'an OrderedCollection(a Dictionary(#class->ByteString #id->1 #name->#someString #type->#primitive #value->''abcd'' ) a Dictionary(#class->SmallInteger #equalReceiver->false #id->2 #name->#tmp1 #type->#primitive #value->''4'' ) a Dictionary(#class->ByteString #id->3 #name->#someString #type->#primitive #value->''abcd0'' ) a Dictionary(#class->ByteString #equalReceiver->true #id->4 #name->#someString #type->#primitive #value->''abcd0'' ) a Dictionary(#id->5 #name->#Array ) a Dictionary(#class->Array #equalReceiver->false #id->6 #name->#tmp2 #type->#collection #value->an OrderedCollection(a Dictionary(#class->SmallInteger #type->#primitive #value->''1'' ) a Dictionary(#class->SmallInteger #type->#primitive #value->''2'' )) ))'