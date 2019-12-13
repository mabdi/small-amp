"
A SAObservationObjectTest is a test class for testing the behavior of SAObservationObject
"
Class {
	#name : #SAObservationObjectTest,
	#superclass : #TestCase,
	#category : #'Amplification-Tests-Model'
}

{ #category : #tests }
SAObservationObjectTest >> testMaxDepth [
	| item deepObj |
	deepObj := #key -> (Array with: { (10 @ 20 corner: 20 @ 30) }).
	item := deepObj
		        smallAmpAcceptSerializerVisitor:
		        SAObjectObserversSerializer new
		        atDepth: 0.
	self assert: item depth equals: 0.
	self assert: (item theValue at: #value) depth equals: 1.
	self assert: ((item theValue at: #value) theValue at: 1) depth equals: 2.
	self assert: (((item theValue at: #value) theValue at: 1) theValue at: 1) depth equals: 3.
	self
		assert: (((item theValue at: #value) theValue at: 1) theValue at: 1) theValue class
		equals: Dictionary.
	self
		assert: (((item theValue at: #value) theValue at: 1) theValue at: 1) theValue size
		equals: 0.
]

{ #category : #tests }
SAObservationObjectTest >> testPoint [
	| item obj |
	obj := 10 @ 20.
	item := obj
		        smallAmpAcceptSerializerVisitor:
		        SAObjectObserversSerializer new
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
SAObservationObjectTest >> testRecangle [
	| item obj |
	obj := 10 @ 20 corner: 20 @ 30.
	item := obj
		        smallAmpAcceptSerializerVisitor:
		        SAObjectObserversSerializer new
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
	self assert: (item theValue at: #corners) theValue size equals: 4.
	
]

{ #category : #tests }
SAObservationObjectTest >> testSmallBank [
	| item obj |
	obj := SmallBank new.
	item := obj
		        smallAmpAcceptSerializerVisitor:
		        SAObjectObserversSerializer new
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
		        SAObjectObserversSerializer new
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
