"
A SAObjectObserversSerializerTest is a test class for testing the behavior of SAObjectObserversSerializer
"
Class {
	#name : #SAStateSerializerTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Helpers'
}

{ #category : #'as yet unclassified' }
SAStateSerializerTest >> getASerializer [
	^ SAStateSerializer new
]

{ #category : #tests }
SAStateSerializerTest >> testArray [
	| item arr s1 |
	arr := Array with: 10 with: 20 with: 30.
	item := arr
		        smallAmpAcceptSerializerVisitor: self getASerializer
		        atDepth: 0.
	self assert: item class equals: SAObservationCollection.
	self assert: item theClass equals: Array.
	self assert: item theValue isNotEmpty.
	self assert: item theValue size equals: 3.
	s1 := 10
		      smallAmpAcceptSerializerVisitor:
		      self getASerializer
		      atDepth: 0.
	self assert: (item theValue at: 1) theClass equals: s1 theClass.
	self assert: (item theValue at: 1) theValue equals: s1 theValue.
	self assert: (item theValue at: 2) theValue equals: 20.
	self assert: (item theValue at: 2) theClass equals: SmallInteger
]

{ #category : #tests }
SAStateSerializerTest >> testArray2D [
	| item matrix23 s1 |
	matrix23 := Array2D rows: 3 columns: 2.
	matrix23 at: 1 at: 1 put: 11.
	matrix23 at: 1 at: 2 put: 21.
	matrix23 at: 2 at: 1 put: 12.
	matrix23 at: 2 at: 2 put: 22.
	matrix23 at: 3 at: 1 put: 13.
	matrix23 at: 3 at: 2 put: 23.
	item := matrix23
		smallAmpAcceptSerializerVisitor: self getASerializer
		atDepth: 0.
	self assert: item class equals: SAObservationObject.
	self assert: item theClass equals: Array2D.
	self assert: item theValue isNotEmpty.
	self assert: item theValue size equals: 14.
	s1 := 12
		smallAmpAcceptSerializerVisitor: self getASerializer
		atDepth: 0.
	self assert: (item theValue at: #rowCount) theValue equals: 3.
	self assert: (item theValue at: #isCollection) theValue. 
		
]

{ #category : #tests }
SAStateSerializerTest >> testArrayDeep [
	| item arr s2 |
	arr := Array with: 10 with: { 'hello'. 1. true }.
	item := arr
		        smallAmpAcceptSerializerVisitor: self getASerializer
		        atDepth: 0.
	self assert: item class equals: SAObservationCollection.
	self assert: item theClass equals: Array.
	self assert: item theValue isNotEmpty.
	self assert: item theValue size equals: 2.
	s2 := { 'hello'. 1. true }
		      smallAmpAcceptSerializerVisitor:
		      self getASerializer
		      atDepth: 0.
	self
		assert: (item theValue at: 2) class
		equals: SAObservationCollection.
	self assert: (item theValue at: 2) theClass equals: s2 theClass.
	self assert: (item theValue at: 2) theClass equals: Array.
	self assert: (item theValue at: 2) theValue size equals: 3.
	self
		assert: ((item theValue at: 2) theValue at: 1) class
		equals: SAObservationPrimitive.
	self
		assert: ((item theValue at: 2) theValue at: 1) theValue
		equals: 'hello'.
	self
		assert: ((item theValue at: 2) theValue at: 2) theValue
		equals: 1.
	self
		assert: ((item theValue at: 2) theValue at: 3) theValue
		equals: true
]

{ #category : #tests }
SAStateSerializerTest >> testBoolean [
	| item obj |
	obj := true.
	item := obj
		        smallAmpAcceptSerializerVisitor:
		        self getASerializer
		        atDepth: 0.
	self assert: item class equals: SAObservationTrue.
	self assert: item theClass equals: True.
	self assert: item theValue equals: true
]

{ #category : #tests }
SAStateSerializerTest >> testCharacter [
	| item obj |
	obj := $r.
	item := obj
		        smallAmpAcceptSerializerVisitor:
		        self getASerializer
		        atDepth: 0.
	self assert: item class equals: SAObservationPrimitive.
	self assert: item theClass equals: Character.
	self assert: item theValue equals: $r
]

{ #category : #tests }
SAStateSerializerTest >> testError [
	| item |
	item := SAObservationError forError: OutOfMemory.
	self assert: item theError equals: OutOfMemory
]

{ #category : #test }
SAStateSerializerTest >> testFilterObserversOn [
	"Here we are testing the filterObserversOn on a few different type"

	"this test may fail, depend on change on the structure of these types"

	| obj res serializer |
	obj := SmallBank new.
	serializer := self getASerializer.
	res := serializer filterObserversOn: obj.
	"an OrderedCollection(SmallBank>>#balance SmallBank>>#rand)"
	self assert: res size equals: 2.
	obj := SAObservationObject new.
	res := serializer filterObserversOn: obj.
	self assert: res size equals: 7.
	"an OrderedCollection(SAObservationValue>>#depth SAObservationValue>>#isFlaky SAObservationValue>>#isValueObservation SAObservationValue>>#name SAObservationValue>>#observedBy SAObservationValue>>#theClass SAObservationValue>>#theValue)"
	obj := SAObservationPrimitive new.
	res := serializer filterObserversOn: obj.
	self assert: res size equals: 1.
	"an OrderedCollection(SAObservationPrimitive>>#isPrimitive)"
	obj := #key -> 0.
	res := serializer filterObserversOn: obj.
	self assert: res size equals: 5.
	"an OrderedCollection(LookupKey>>#isVariableBinding LookupKey>>#key LookupKey>>#name Association>>#needsFullDefinition Association>>#value)"
	obj := 1 @ 1.
	res := serializer filterObserversOn: obj.
	self assert: res size equals: 6
	"an OrderedCollection(Point>>#isFloatPoint Point>>#isIntegerPoint Point>>#isPoint Point>>#isZero Point>>#x Point>>#y)"
]

{ #category : #tests }
SAStateSerializerTest >> testFloat [
	| item obj |
	obj := 3.14.
	item := obj
		        smallAmpAcceptSerializerVisitor:
		        self getASerializer
		        atDepth: 0.
	self assert: item class equals: SAObservationPrimitive.
	self assert: item theClass equals: SmallFloat64.
	self assert: item theValue equals: 3.14
]

{ #category : #tests }
SAStateSerializerTest >> testFraction [
	| item obj |
	obj := 1 / 2.
	item := obj
		        smallAmpAcceptSerializerVisitor:
		        self getASerializer
		        atDepth: 0.
	self assert: item class equals: SAObservationPrimitive.
	self assert: item theClass equals: Fraction.
	self assert: item theValue equals: 1 / 2
]

{ #category : #tests }
SAStateSerializerTest >> testInteger [
	| item obj |
	obj := 1368.
	item := obj
		        smallAmpAcceptSerializerVisitor:
		        self getASerializer
		        atDepth: 0.
	self assert: item class equals: SAObservationPrimitive.
	self assert: item theClass equals: SmallInteger.
	self assert: item theValue equals: 1368
]

{ #category : #tests }
SAStateSerializerTest >> testMaxDepth [
	| item deepObj |
	deepObj := #key -> (Array with: { (10 @ 20 corner: 20 @ 30) }).
	item := deepObj
		        smallAmpAcceptSerializerVisitor:
		        self getASerializer
		        atDepth: 0.
	self assert: item depth equals: 0.
	self assert: (item theValue at: #value) depth equals: 1.
	self
		assert: ((item theValue at: #value) theValue at: 1) depth
		equals: 2.
	self
		assert:
		(((item theValue at: #value) theValue at: 1) theValue at: 1) isNil.
	
]

{ #category : #tests }
SAStateSerializerTest >> testNil [
	| item obj |
	obj := nil.
	item := obj
		        smallAmpAcceptSerializerVisitor:
		        self getASerializer
		        atDepth: 0.
	self assert: item class equals: SAObservationNil.
	self assert: item theClass equals: UndefinedObject.
	self assert: item theValue equals: nil
]

{ #category : #tests }
SAStateSerializerTest >> testPoint [
	| item obj |
	obj := 10 @ 20.
	item := obj
		        smallAmpAcceptSerializerVisitor:
		        self getASerializer
		        atDepth: 0.
	self assert: item class equals: SAObservationObject.
	self assert: item theClass equals: Point.
	self assert: item theValue class equals: Dictionary.
	self assert: item theValue size equals: 6.
	self
		assert: (item theValue at: #x) class
		equals: SAObservationPrimitive.
	self assert: (item theValue at: #x) theValue equals: 10.
	self assert: (item theValue at: #y) theValue equals: 20.
	self assert: (item theValue at: #isZero) theValue equals: false
]

{ #category : #tests }
SAStateSerializerTest >> testRecangle [
	| item obj |
	obj := 10 @ 20 corner: 20 @ 30.
	item := obj
		        smallAmpAcceptSerializerVisitor:
		        self getASerializer
		        atDepth: 0.
	self assert: item class equals: SAObservationObject.
	self assert: item theClass equals: Rectangle.
	self assert: item theValue class equals: Dictionary.
	self assert: item theValue size equals: 28.
	self
		assert: (item theValue at: #top) class
		equals: SAObservationPrimitive.
	self assert: (item theValue at: #top) theValue equals: 20.
	self
		assert: (item theValue at: #extent) class
		equals: SAObservationObject.
	self assert: (item theValue at: #extent) theClass equals: Point.
	self
		assert: (item theValue at: #corners) class
		equals: SAObservationCollection.
	self assert: (item theValue at: #corners) theValue size equals: 4
]

{ #category : #tests }
SAStateSerializerTest >> testSmallBank [
	| item obj |
	obj := SmallBank new.
	item := obj
		        smallAmpAcceptSerializerVisitor:
		        self getASerializer
		        atDepth: 0.
	self assert: item class equals: SAObservationObject.
	self assert: item theClass equals: SmallBank.
	self assert: item theValue class equals: Dictionary.
	self assert: item theValue size equals: 2.
	self
		assert: (item theValue at: #balance) class
		equals: SAObservationPrimitive.
	self assert: (item theValue at: #balance) theValue equals: 0.
	obj deposit: 100.
	item := obj
		        smallAmpAcceptSerializerVisitor:
		        self getASerializer
		        atDepth: 0.
	self assert: item class equals: SAObservationObject.
	self assert: item theClass equals: SmallBank.
	self assert: item theValue class equals: Dictionary.
	self assert: item theValue size equals: 2.
	self
		assert: (item theValue at: #balance) class
		equals: SAObservationPrimitive.
	self assert: (item theValue at: #balance) theValue equals: 100
]

{ #category : #tests }
SAStateSerializerTest >> testString [
	| item obj |
	obj := 'Hello World!'.
	item := obj
		        smallAmpAcceptSerializerVisitor:
		        self getASerializer
		        atDepth: 0.
	self assert: item class equals: SAObservationPrimitive.
	self assert: item theClass equals: ByteString.
	self assert: item theValue equals: 'Hello World!'
]

{ #category : #tests }
SAStateSerializerTest >> testTimeout [
	| item |
	item := SAObservationTimeout forTimeout: 125.
	self assert: item timeout equals: 125
]
