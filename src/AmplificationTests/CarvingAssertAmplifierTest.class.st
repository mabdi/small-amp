Class {
	#name : #CarvingAssertAmplifierTest,
	#superclass : #TestCase,
	#instVars : [
		'instance'
	],
	#category : #AmplificationTests
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
	generatedClass := instance buildAuxillaryClass: aMethod basedOn: aClass.
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
	self assert: array size equals: 1 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	tmp1 := array at: 1 put: someVariable.
	self assert: array size equals: 1 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	self assert: tmp1 equals: 1 description: ''smallAmp''.
	self
		assert: tmp1 class
		equals: SmallInteger
		description: ''smallAmp''.
	tmp2 := array add: someVariable + 10.
	self assert: array size equals: 2 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	self assert: tmp2 equals: 11 description: ''smallAmp''.
	self
		assert: tmp2 class
		equals: SmallInteger
		description: ''smallAmp''.
	tmp3 := array addAll: {12 . 13}.
	self assert: array size equals: 4 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	self assert: tmp3 size equals: 2 description: ''smallAmp''.
	self
		assert: tmp3 class
		equals: Array
		description: ''smallAmp''.
	tmp4 := array add: someVariable * 4.
	self assert: array size equals: 5 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	self assert: tmp4 equals: 4 description: ''smallAmp''.
	self
		assert: tmp4 class
		equals: SmallInteger
		description: ''smallAmp''.
	tmp5 := array remove: someVariable.
	self assert: array size equals: 4 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	self assert: tmp5 equals: 1 description: ''smallAmp''.
	self
		assert: tmp5 class
		equals: SmallInteger
		description: ''smallAmp''.
	tmp6 := array at: 2 put: 3000.
	self assert: array size equals: 4 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	self assert: tmp6 equals: 3000 description: ''smallAmp''.
	self
		assert: tmp6 class
		equals: SmallInteger
		description: ''smallAmp''.
	tmp7 := array removeAt: 2.
	self assert: array size equals: 3 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	self assert: tmp7 equals: 3000 description: ''smallAmp''.
	self
		assert: tmp7 class
		equals: SmallInteger
		description: ''smallAmp''.
	tmp8 := array removeAll.
	self assert: array size equals: 0 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp'''
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
	generatedClass := instance buildAuxillaryClass: aMethod basedOn: aClass.
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
	self assert: array size equals: 0 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	tmp1 := array add: someVariable.
	self assert: array size equals: 1 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	self assert: tmp1 equals: 1 description: ''smallAmp''.
	self
		assert: tmp1 class
		equals: SmallInteger
		description: ''smallAmp'''
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
	generatedClass := instance buildAuxillaryClass: aMethod basedOn: aClass.
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
	self assert: array size equals: 3 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	tmp1 := array add: 40.
	self assert: array size equals: 4 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	self assert: tmp1 equals: 40 description: ''smallAmp''.
	self
		assert: tmp1 class
		equals: SmallInteger
		description: ''smallAmp''.
	tmp2 := array add: 11 after: 10.
	self assert: array size equals: 5 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	self assert: tmp2 equals: 11 description: ''smallAmp''.
	self
		assert: tmp2 class
		equals: SmallInteger
		description: ''smallAmp''.
	tmp3 := array add: 21 afterIndex: 3.
	self assert: array size equals: 6 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	self assert: tmp3 equals: 21 description: ''smallAmp''.
	self
		assert: tmp3 class
		equals: SmallInteger
		description: ''smallAmp'''
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
	generatedClass := instance buildAuxillaryClass: aMethod basedOn: aClass.
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
	self assert: array size equals: 3 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	tmp1 := array at: 2 put: 2000.
	self assert: array size equals: 3 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	self assert: tmp1 equals: 2000 description: ''smallAmp''.
	self
		assert: tmp1 class
		equals: SmallInteger
		description: ''smallAmp'''
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
	generatedClass := instance buildAuxillaryClass: aMethod basedOn: aClass.
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
	self assert: array size equals: 3 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	tmp1 := array add: 40.
	self assert: array size equals: 4 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	self assert: tmp1 equals: 40 description: ''smallAmp''.
	self
		assert: tmp1 class
		equals: SmallInteger
		description: ''smallAmp''.
	tmp2 := array remove: 20.
	self assert: array size equals: 3 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	self assert: tmp2 equals: 20 description: ''smallAmp''.
	self
		assert: tmp2 class
		equals: SmallInteger
		description: ''smallAmp'''
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
	generatedClass := instance buildAuxillaryClass: aMethod basedOn: aClass.
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
	self assert: array size equals: 3 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	tmp1 := array add: 40.
	self assert: array size equals: 4 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	self assert: tmp1 equals: 40 description: ''smallAmp''.
	self
		assert: tmp1 class
		equals: SmallInteger
		description: ''smallAmp''.
	tmp2 := array at: 1 put: 100.
	self assert: array size equals: 4 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	self assert: tmp2 equals: 100 description: ''smallAmp''.
	self
		assert: tmp2 class
		equals: SmallInteger
		description: ''smallAmp''.
	tmp3 := array remove: 20.
	self assert: array size equals: 3 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	self assert: tmp3 equals: 20 description: ''smallAmp''.
	self
		assert: tmp3 class
		equals: SmallInteger
		description: ''smallAmp'''
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
	generatedClass := instance buildAuxillaryClass: aMethod basedOn: aClass.
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
	self assert: array size equals: 1 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	tmp1 := array add: 10 @ 10.
	self assert: array size equals: 2 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	self
		assert: tmp1 isPoint
		equals: true
		description: ''smallAmp''.
	self
		assert: tmp1 isPoint class
		equals: True
		description: ''smallAmp''.
	self assert: tmp1 x equals: 10 description: ''smallAmp''.
	self
		assert: tmp1 x class
		equals: SmallInteger
		description: ''smallAmp''.
	self
		assert: tmp1 isIntegerPoint
		equals: true
		description: ''smallAmp''.
	self
		assert: tmp1 isIntegerPoint class
		equals: True
		description: ''smallAmp''.
	self
		assert: tmp1 isFloatPoint
		equals: false
		description: ''smallAmp''.
	self
		assert: tmp1 isFloatPoint class
		equals: False
		description: ''smallAmp''.
	self assert: tmp1 y equals: 10 description: ''smallAmp''.
	self
		assert: tmp1 y class
		equals: SmallInteger
		description: ''smallAmp''.
	self
		assert: tmp1 isZero
		equals: false
		description: ''smallAmp''.
	self
		assert: tmp1 isZero class
		equals: False
		description: ''smallAmp''.
	self
		assert: tmp1 class
		equals: Point
		description: ''smallAmp''.
	tmp2 := array add: 100 @ 100.
	self assert: array size equals: 3 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	self
		assert: tmp2 isPoint
		equals: true
		description: ''smallAmp''.
	self
		assert: tmp2 isPoint class
		equals: True
		description: ''smallAmp''.
	self assert: tmp2 x equals: 100 description: ''smallAmp''.
	self
		assert: tmp2 x class
		equals: SmallInteger
		description: ''smallAmp''.
	self
		assert: tmp2 isIntegerPoint
		equals: true
		description: ''smallAmp''.
	self
		assert: tmp2 isIntegerPoint class
		equals: True
		description: ''smallAmp''.
	self
		assert: tmp2 isFloatPoint
		equals: false
		description: ''smallAmp''.
	self
		assert: tmp2 isFloatPoint class
		equals: False
		description: ''smallAmp''.
	self assert: tmp2 y equals: 100 description: ''smallAmp''.
	self
		assert: tmp2 y class
		equals: SmallInteger
		description: ''smallAmp''.
	self
		assert: tmp2 isZero
		equals: false
		description: ''smallAmp''.
	self
		assert: tmp2 isZero class
		equals: False
		description: ''smallAmp''.
	self
		assert: tmp2 class
		equals: Point
		description: ''smallAmp''.
	tmp3 := array at: 2 put: 23 @ 23.
	self assert: array size equals: 3 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	self
		assert: tmp3 isPoint
		equals: true
		description: ''smallAmp''.
	self
		assert: tmp3 isPoint class
		equals: True
		description: ''smallAmp''.
	self assert: tmp3 x equals: 23 description: ''smallAmp''.
	self
		assert: tmp3 x class
		equals: SmallInteger
		description: ''smallAmp''.
	self
		assert: tmp3 isIntegerPoint
		equals: true
		description: ''smallAmp''.
	self
		assert: tmp3 isIntegerPoint class
		equals: True
		description: ''smallAmp''.
	self
		assert: tmp3 isFloatPoint
		equals: false
		description: ''smallAmp''.
	self
		assert: tmp3 isFloatPoint class
		equals: False
		description: ''smallAmp''.
	self assert: tmp3 y equals: 23 description: ''smallAmp''.
	self
		assert: tmp3 y class
		equals: SmallInteger
		description: ''smallAmp''.
	self
		assert: tmp3 isZero
		equals: false
		description: ''smallAmp''.
	self
		assert: tmp3 isZero class
		equals: False
		description: ''smallAmp''.
	self
		assert: tmp3 class
		equals: Point
		description: ''smallAmp''.
	tmp4 := array removeAt: 3.
	self assert: array size equals: 2 description: ''smallAmp''.
	self
		assert: array class
		equals: OrderedCollection
		description: ''smallAmp''.
	self
		assert: tmp4 isPoint
		equals: true
		description: ''smallAmp''.
	self
		assert: tmp4 isPoint class
		equals: True
		description: ''smallAmp''.
	self assert: tmp4 x equals: 100 description: ''smallAmp''.
	self
		assert: tmp4 x class
		equals: SmallInteger
		description: ''smallAmp''.
	self
		assert: tmp4 isIntegerPoint
		equals: true
		description: ''smallAmp''.
	self
		assert: tmp4 isIntegerPoint class
		equals: True
		description: ''smallAmp''.
	self
		assert: tmp4 isFloatPoint
		equals: false
		description: ''smallAmp''.
	self
		assert: tmp4 isFloatPoint class
		equals: False
		description: ''smallAmp''.
	self assert: tmp4 y equals: 100 description: ''smallAmp''.
	self
		assert: tmp4 y class
		equals: SmallInteger
		description: ''smallAmp''.
	self
		assert: tmp4 isZero
		equals: false
		description: ''smallAmp''.
	self
		assert: tmp4 isZero class
		equals: False
		description: ''smallAmp''.
	self
		assert: tmp4 class
		equals: Point
		description: ''smallAmp'''
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
	generatedClass := instance buildAuxillaryClass: aMethod basedOn: aClass.
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
	self assert: node isPoint equals: true description: ''smallAmp''.
	self assert: node isPoint class equals: True description: ''smallAmp''.
	self assert: node x equals: 3 description: ''smallAmp''.
	self
		assert: node x class
		equals: SmallInteger
		description: ''smallAmp''.
	self assert: node isIntegerPoint equals: true description: ''smallAmp''.
	self
		assert: node isIntegerPoint class
		equals: True
		description: ''smallAmp''.
	self assert: node isFloatPoint equals: false description: ''smallAmp''.
	self
		assert: node isFloatPoint class
		equals: False
		description: ''smallAmp''.
	self assert: node y equals: 1 description: ''smallAmp''.
	self
		assert: node y class
		equals: SmallInteger
		description: ''smallAmp''.
	self assert: node isZero equals: false description: ''smallAmp''.
	self assert: node isZero class equals: False description: ''smallAmp''.
	self assert: node class equals: Point description: ''smallAmp''.
	node := node + (10 @ 10).
	self assert: node isPoint equals: true description: ''smallAmp''.
	self assert: node isPoint class equals: True description: ''smallAmp''.
	self assert: node x equals: 13 description: ''smallAmp''.
	self
		assert: node x class
		equals: SmallInteger
		description: ''smallAmp''.
	self assert: node isIntegerPoint equals: true description: ''smallAmp''.
	self
		assert: node isIntegerPoint class
		equals: True
		description: ''smallAmp''.
	self assert: node isFloatPoint equals: false description: ''smallAmp''.
	self
		assert: node isFloatPoint class
		equals: False
		description: ''smallAmp''.
	self assert: node y equals: 11 description: ''smallAmp''.
	self
		assert: node y class
		equals: SmallInteger
		description: ''smallAmp''.
	self assert: node isZero equals: false description: ''smallAmp''.
	self assert: node isZero class equals: False description: ''smallAmp''.
	self assert: node class equals: Point description: ''smallAmp''.
	node1 := node dist: 0 @ 1.
	self assert: node isPoint equals: true description: ''smallAmp''.
	self assert: node isPoint class equals: True description: ''smallAmp''.
	self assert: node x equals: 13 description: ''smallAmp''.
	self
		assert: node x class
		equals: SmallInteger
		description: ''smallAmp''.
	self assert: node isIntegerPoint equals: true description: ''smallAmp''.
	self
		assert: node isIntegerPoint class
		equals: True
		description: ''smallAmp''.
	self assert: node isFloatPoint equals: false description: ''smallAmp''.
	self
		assert: node isFloatPoint class
		equals: False
		description: ''smallAmp''.
	self assert: node y equals: 11 description: ''smallAmp''.
	self
		assert: node y class
		equals: SmallInteger
		description: ''smallAmp''.
	self assert: node isZero equals: false description: ''smallAmp''.
	self assert: node isZero class equals: False description: ''smallAmp''.
	self assert: node class equals: Point description: ''smallAmp''.
	self assert: node1 equals: 16.401219466856727 description: ''smallAmp''.
	self assert: node1 class equals: SmallFloat64 description: ''smallAmp'''
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
	generatedClass := instance buildAuxillaryClass: aMethod basedOn: aClass.
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
	self assert: someVariable equals: 2 description: ''smallAmp''.
	self
		assert: someVariable class
		equals: SmallInteger
		description: ''smallAmp''.
	tmp1 := someVariable - 1.
	self assert: someVariable equals: 2 description: ''smallAmp''.
	self
		assert: someVariable class
		equals: SmallInteger
		description: ''smallAmp''.
	self assert: tmp1 equals: 1 description: ''smallAmp''.
	self assert: tmp1 class equals: SmallInteger description: ''smallAmp''.
	someString := someString , ''111''.
	self assert: someString equals: ''abcd111'' description: ''smallAmp''.
	self
		assert: someString class
		equals: ByteString
		description: ''smallAmp'''
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
	generatedClass := instance buildAuxillaryClass: aMethod basedOn: aClass.
	generatedClass suite run.
	3
		timesRepeat: [ generatedClass observer resetFlakyDetection.
			generatedClass suite run.
			generatedClass observer checkFlaky ].	"Flaky detection"
	observer := generatedClass observer.
	
	"generatedClass removeFromSystem."
	instance insertAsserts: aMethod using: observer.
	self
		assert: (GeneralHelper renameTempVars: aMethod formattedCode)
		equals:
			'testFoo
	| b tmp1 |
	b := SmallBank new.
	self assert: b balance equals: 0 description: ''smallAmp''.
	self
		assert: b balance class
		equals: SmallInteger
		description: ''smallAmp''.
	self assert: b class equals: SmallBank description: ''smallAmp''.
	tmp1 := b deposit: 100.
	self assert: b balance equals: 100 description: ''smallAmp''.
	self
		assert: b balance class
		equals: SmallInteger
		description: ''smallAmp''.
	self assert: b class equals: SmallBank description: ''smallAmp'''
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
	generatedClass := instance buildAuxillaryClass: aMethod basedOn: aClass.
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
			'an OrderedCollection(a Dictionary(#class->ByteString #id->1 #name->#someString #observedby->#observe #type->#primitive #value->''abcd'' ) a Dictionary(#class->SmallInteger #equalReceiver->false #id->2 #name->#tmp1 #observedby->#observeResult #type->#primitive #value->''4'' ) a Dictionary(#class->ByteString #id->3 #name->#someString #observedby->#observe #type->#primitive #value->''abcd0'' ) a Dictionary(#class->ByteString #equalReceiver->true #id->4 #name->#someString #observedby->#observeResult #type->#primitive #value->''abcd0'' ) a Dictionary(#id->5 #name->#Array #observedby->#observe ) a Dictionary(#class->Array #equalReceiver->false #id->6 #name->#tmp2 #observedby->#observeResult #type->#collection #value->an OrderedCollection(a Dictionary(#class->SmallInteger #type->#primitive #value->''1'' ) a Dictionary(#class->SmallInteger #type->#primitive #value->''2'' )) ))'
]
