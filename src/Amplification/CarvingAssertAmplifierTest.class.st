Class {
	#name : #CarvingAssertAmplifierTest,
	#superclass : #TestCase,
	#instVars : [
		'instance'
	],
	#category : #'Amplification-Tests'
}

{ #category : #running }
CarvingAssertAmplifierTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
instance := CarvingAssertAmplifier new
	
]

{ #category : #tests }
CarvingAssertAmplifierTest >> testAssertionGenerationCollection [
	| aMethod aClass generatedClass observer |
	aMethod := RBParser
		parseMethod:
			'testFoo
	| array |
	array := OrderedCollection with: 56.
	array at: 1 put: someVariable.
	array add: someVariable + 10.
	array addAll: { 12 . 13 }.
	array add: someVariable * 4.
	array remove: someVariable.
	array at: 2 put: 3000.
	array removeAt: 2.
	array removeAll
	'.
	aClass := FakeTestcase.
	instance insertObservers: aMethod.
	generatedClass := instance buildAxularyClass: aMethod basedOn: aClass.
	generatedClass suite run.
	observer := generatedClass observer.
	ASTHelper uniqueInstance removeClass: generatedClass  source: self class name..
	instance insertAsserts: aMethod using: observer.
	self
		assert: (GeneralHelper renameTempVars: aMethod formattedCode)
		equals:
			'testFoo
	| array tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7 tmp8 |
	array := OrderedCollection with: 56.
	self assert: array size equals: 1.
	tmp1 := array at: 1 put: someVariable.
	self assert: array size equals: 1.
	self assert: tmp1 equals: 1.
	tmp2 := array add: someVariable + 10.
	self assert: array size equals: 2.
	self assert: tmp2 equals: 11.
	tmp3 := array addAll: {12 . 13}.
	self assert: array size equals: 4.
	self assert: tmp3 size equals: 2.
	tmp4 := array add: someVariable * 4.
	self assert: array size equals: 5.
	self assert: tmp4 equals: 4.
	tmp5 := array remove: someVariable.
	self assert: array size equals: 4.
	self assert: tmp5 equals: 1.
	tmp6 := array at: 2 put: 3000.
	self assert: array size equals: 4.
	self assert: tmp6 equals: 3000.
	tmp7 := array removeAt: 2.
	self assert: array size equals: 3.
	self assert: tmp7 equals: 3000.
	tmp8 := array removeAll.
	self assert: array size equals: 0'
]

{ #category : #tests }
CarvingAssertAmplifierTest >> testAssertionGenerationCollection1 [
	| aMethod aClass generatedClass observer |
	aMethod := RBParser
		parseMethod:
			'testFoo
	| array |
	array := OrderedCollection new.
	array add: someVariable
	'.
	aClass := FakeTestcase.
	instance insertObservers: aMethod.
	generatedClass := instance buildAxularyClass: aMethod basedOn: aClass.
	generatedClass suite run.
	observer := generatedClass observer.
	ASTHelper uniqueInstance removeClass: generatedClass  source: self class name..
	instance insertAsserts: aMethod using: observer.
	self
		assert: (GeneralHelper renameTempVars: aMethod formattedCode)
		equals:
			'testFoo
	| array tmp1 |
	array := OrderedCollection new.
	self assert: array size equals: 0.
	tmp1 := array add: someVariable.
	self assert: array size equals: 1.
	self assert: tmp1 equals: 1'
]

{ #category : #tests }
CarvingAssertAmplifierTest >> testAssertionGenerationCollectionAdd [
	| aMethod aClass generatedClass observer |
	aMethod := RBParser
		parseMethod:
			'testFoo
	| array |
	array := OrderedCollection with:10 with:20 with:30.
	array add: 40.
	array add: 11 after: 10.
	array add: 21 afterIndex: 3
	'.
	aClass := FakeTestcase.
	instance insertObservers: aMethod.
	generatedClass := instance buildAxularyClass: aMethod basedOn: aClass.
	generatedClass suite run.
	observer := generatedClass observer.
	ASTHelper uniqueInstance removeClass: generatedClass  source: self class name..
	instance insertAsserts: aMethod using: observer.
	self
		assert: (GeneralHelper renameTempVars: aMethod formattedCode)
		equals:
			'testFoo
	| array tmp1 tmp2 tmp3 |
	array := OrderedCollection with: 10 with: 20 with: 30.
	self assert: array size equals: 3.
	tmp1 := array add: 40.
	self assert: array size equals: 4.
	self assert: tmp1 equals: 40.
	tmp2 := array add: 11 after: 10.
	self assert: array size equals: 5.
	self assert: tmp2 equals: 11.
	tmp3 := array add: 21 afterIndex: 3.
	self assert: array size equals: 6.
	self assert: tmp3 equals: 21'
]

{ #category : #tests }
CarvingAssertAmplifierTest >> testAssertionGenerationCollectionChange [
	| aMethod aClass generatedClass observer |
	aMethod := RBParser
		parseMethod:
			'testFoo
	| array |
	array := OrderedCollection with:10 with:20 with:30.
	array at: 2 put: 2000
	'.
	aClass := FakeTestcase.
	instance insertObservers: aMethod.
	generatedClass := instance buildAxularyClass: aMethod basedOn: aClass.
	generatedClass suite run.
	observer := generatedClass observer.
	ASTHelper uniqueInstance removeClass: generatedClass  source: self class name..
	instance insertAsserts: aMethod using: observer.
	self
		assert: (GeneralHelper renameTempVars: aMethod formattedCode)
		equals:
			'testFoo
	| array tmp1 |
	array := OrderedCollection with: 10 with: 20 with: 30.
	self assert: array size equals: 3.
	tmp1 := array at: 2 put: 2000.
	self assert: array size equals: 3.
	self assert: tmp1 equals: 2000'
]

{ #category : #tests }
CarvingAssertAmplifierTest >> testAssertionGenerationCollectionRemove [
	| aMethod aClass generatedClass observer |
	aMethod := RBParser
		parseMethod:
			'testFoo
	| array |
	array := OrderedCollection with:10 with:20 with:30.
	array add: 40.
	array remove: 20
	'.
	aClass := FakeTestcase.
	instance insertObservers: aMethod.
	generatedClass := instance buildAxularyClass: aMethod basedOn: aClass.
	generatedClass suite run.
	observer := generatedClass observer.
	ASTHelper uniqueInstance removeClass: generatedClass  source: self class name..
	instance insertAsserts: aMethod using: observer.
	self
		assert: (GeneralHelper renameTempVars: aMethod formattedCode)
		equals:
			'testFoo
	| array tmp1 tmp2 |
	array := OrderedCollection with: 10 with: 20 with: 30.
	self assert: array size equals: 3.
	tmp1 := array add: 40.
	self assert: array size equals: 4.
	self assert: tmp1 equals: 40.
	tmp2 := array remove: 20.
	self assert: array size equals: 3.
	self assert: tmp2 equals: 20'
]

{ #category : #tests }
CarvingAssertAmplifierTest >> testAssertionGenerationCollectionSize [
	| aMethod aClass generatedClass observer |
	aMethod := RBParser
		parseMethod:
			'testFoo
	| array |
	array := OrderedCollection with:10 with:20 with:30.
	array add: 40.
	array at: 1 put: 100.
	array remove: 20
	'.
	aClass := FakeTestcase.
	instance insertObservers: aMethod.
	generatedClass := instance buildAxularyClass: aMethod basedOn: aClass.
	generatedClass suite run.
	observer := generatedClass observer.
	ASTHelper uniqueInstance removeClass: generatedClass  source: self class name..
	instance insertAsserts: aMethod using: observer.
	self
		assert: (GeneralHelper renameTempVars: aMethod formattedCode)
		equals:
			'testFoo
	| array tmp1 tmp2 tmp3 |
	array := OrderedCollection with: 10 with: 20 with: 30.
	self assert: array size equals: 3.
	tmp1 := array add: 40.
	self assert: array size equals: 4.
	self assert: tmp1 equals: 40.
	tmp2 := array at: 1 put: 100.
	self assert: array size equals: 4.
	self assert: tmp2 equals: 100.
	tmp3 := array remove: 20.
	self assert: array size equals: 3.
	self assert: tmp3 equals: 20'
]

{ #category : #tests }
CarvingAssertAmplifierTest >> testAssertionGenerationComplex [
	| aMethod aClass generatedClass observer |
	aMethod := RBParser
		parseMethod:
			'testFoo
	| array |
	array := OrderedCollection with: 1@1.
	array add: (10@10).
	array add: (100@100).
	array at: 2 put: (23@23).
	array removeAt:3
	'.
	aClass := FakeTestcase.
	instance insertObservers: aMethod.
	generatedClass := instance buildAxularyClass: aMethod basedOn: aClass.
	generatedClass suite run.
	observer := generatedClass observer.
	ASTHelper uniqueInstance removeClass: generatedClass  source: self class name..
	instance insertAsserts: aMethod using: observer.
	self
		assert: (GeneralHelper renameTempVars: aMethod formattedCode)
		equals:
			'testFoo
	| array tmp1 tmp2 tmp3 tmp4 |
	array := OrderedCollection with: 1 @ 1.
	self assert: array size equals: 1.
	tmp1 := array add: 10 @ 10.
	self assert: array size equals: 2.
	self assert: tmp1 x equals: 10.
	self assert: tmp1 y equals: 10.
	tmp2 := array add: 100 @ 100.
	self assert: array size equals: 3.
	self assert: tmp2 x equals: 100.
	self assert: tmp2 y equals: 100.
	tmp3 := array at: 2 put: 23 @ 23.
	self assert: array size equals: 3.
	self assert: tmp3 x equals: 23.
	self assert: tmp3 y equals: 23.
	tmp4 := array removeAt: 3.
	self assert: array size equals: 2.
	self assert: tmp4 x equals: 100.
	self assert: tmp4 y equals: 100'
]

{ #category : #tests }
CarvingAssertAmplifierTest >> testAssertionGenerationObject [
	| aMethod aClass generatedClass observer |
	aMethod := RBParser
		parseMethod:
			'testFoo
	| node node1 |
	node := 3@1.
	node := node + (10@10).
	node1 := node dist: (0@1)
	'.
	aClass := FakeTestcase.
	instance insertObservers: aMethod.
	generatedClass := instance buildAxularyClass: aMethod basedOn: aClass.
	generatedClass suite run.
	observer := generatedClass observer.
	ASTHelper uniqueInstance removeClass: generatedClass  source: self class name..
	instance insertAsserts: aMethod using: observer.
	self
		assert: (GeneralHelper renameTempVars: aMethod formattedCode)
		equals:
			'testFoo
	| node node1 |
	node := 3 @ 1.
	self assert: node x equals: 3.
	self assert: node y equals: 1.
	node := node + (10 @ 10).
	self assert: node x equals: 13.
	self assert: node y equals: 11.
	node1 := node dist: 0 @ 1.
	self assert: node x equals: 13.
	self assert: node y equals: 11.
	self assert: node1 equals: 16.401219466856727'
]

{ #category : #tests }
CarvingAssertAmplifierTest >> testAssertionGenerationPrimitive [
	| aMethod aClass generatedClass observer |
	aMethod := RBParser
		parseMethod:
			'testFoo
	| tmp1|
	tmp1 := 1.
	someVariable := someVariable + tmp1.
	tmp1 := someVariable - 1.
	someString := someString, ''111'''.
	aClass := FakeTestcase.
	instance insertObservers: aMethod.
	generatedClass := instance buildAxularyClass: aMethod basedOn: aClass.
	generatedClass suite run.
	observer := generatedClass observer.
	ASTHelper uniqueInstance removeClass: generatedClass  source: self class name..
	instance insertAsserts: aMethod using: observer.
	self
		assert: (GeneralHelper renameTempVars: aMethod formattedCode)
		equals:
			'testFoo
	| tmp1 |
	tmp1 := 1.
	someVariable := someVariable + tmp1.
	self assert: someVariable equals: 2.
	tmp1 := someVariable - 1.
	self assert: someVariable equals: 2.
	self assert: tmp1 equals: 1.
	someString := someString , ''111''.
	self assert: someString equals: ''abcd111'''
]

{ #category : #tests }
CarvingAssertAmplifierTest >> testAssertionGenerationRedundant [
	| aMethod aClass generatedClass observer |
	aMethod := RBParser
		parseMethod:
			'testFoo
	| b |
	b := SmallBank new.
	b deposit: 100.
	'.
	aClass := SmallBankTest .
	instance insertObservers: aMethod.
	generatedClass := instance buildAxularyClass: aMethod basedOn: aClass.
	generatedClass suite run.
	observer := generatedClass observer.
	"generatedClass removeFromSystem."
	instance insertAsserts: aMethod using: observer.
	self
		assert: (GeneralHelper renameTempVars: aMethod formattedCode)
		equals:
			'testFoo
	| b tmp1 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp1 := b deposit: 100.
	self assert: b balance equals: 100'
]

{ #category : #tests }
CarvingAssertAmplifierTest >> testObservationCollection [
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
	ASTHelper uniqueInstance removeClass: generatedClass  source: self class name..
	self assert: anArrayTime sorted equals: anArrayTime.
	self
		assert: aStringNoTime
		equals:
			'an OrderedCollection(a Dictionary(#class->ByteString #id->1 #name->#someString #type->#primitive #value->''abcd'' ) a Dictionary(#class->SmallInteger #equalReceiver->false #id->2 #name->#tmp1 #type->#primitive #value->''4'' ) a Dictionary(#class->ByteString #id->3 #name->#someString #type->#primitive #value->''abcd0'' ) a Dictionary(#class->ByteString #equalReceiver->true #id->4 #name->#someString #type->#primitive #value->''abcd0'' ) a Dictionary(#id->5 #name->#Array ) a Dictionary(#class->Array #equalReceiver->false #id->6 #name->#tmp2 #type->#collection #value->an OrderedCollection(a Dictionary(#class->SmallInteger #type->#primitive #value->''1'' ) a Dictionary(#class->SmallInteger #type->#primitive #value->''2'' )) ))'
]
