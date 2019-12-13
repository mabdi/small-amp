"
A SAObservationPrimitiveTest is a test class for testing the behavior of SAObservationPrimitive
"
Class {
	#name : #SAObservationPrimitiveTest,
	#superclass : #TestCase,
	#category : #'Amplification-Tests-Model'
}

{ #category : #tests }
SAObservationPrimitiveTest >> testBoolean [
	| item obj |
	obj := true.
	item := obj
		        smallAmpAcceptSerializerVisitor:
		        SAObjectObserversSerializer new
		        atDepth: 0.
	self assert: item class equals: SAObservationPrimitive.
	self assert: item theClass equals: True.
	self assert: item theValue equals: true
]

{ #category : #tests }
SAObservationPrimitiveTest >> testCharacter [
	| item obj |
	obj := $r.
	item := obj
		        smallAmpAcceptSerializerVisitor:
		        SAObjectObserversSerializer new
		        atDepth: 0.
	self assert: item class equals: SAObservationPrimitive.
	self assert: item theClass equals: Character.
	self assert: item theValue equals: $r
]

{ #category : #tests }
SAObservationPrimitiveTest >> testFloat [
	| item obj |
	obj := 3.14.
	item := obj
		        smallAmpAcceptSerializerVisitor:
		        SAObjectObserversSerializer new
		        atDepth: 0.
	self assert: item class equals: SAObservationPrimitive.
	self assert: item theClass equals: SmallFloat64.
	self assert: item theValue equals: 3.14
]

{ #category : #tests }
SAObservationPrimitiveTest >> testFraction [
	| item obj |
	obj := 1/2.
	item := obj
		        smallAmpAcceptSerializerVisitor:
		        SAObjectObserversSerializer new
		        atDepth: 0.
	self assert: item class equals: SAObservationPrimitive.
	self assert: item theClass equals: Fraction .
	self assert: item theValue equals: 1/2
]

{ #category : #tests }
SAObservationPrimitiveTest >> testInteger [
	| item obj |
	obj := 1368.
	item := obj
		        smallAmpAcceptSerializerVisitor:
		        SAObjectObserversSerializer new
		        atDepth: 0.
	self assert: item class equals: SAObservationPrimitive.
	self assert: item theClass equals: SmallInteger.
	self assert: item theValue equals: 1368
]

{ #category : #tests }
SAObservationPrimitiveTest >> testNil [
	| item obj |
	obj := nil.
	item := obj
		        smallAmpAcceptSerializerVisitor:
		        SAObjectObserversSerializer new
		        atDepth: 0.
	self assert: item class equals: SAObservationPrimitive.
	self assert: item theClass equals: UndefinedObject .
	self assert: item theValue equals: nil
]

{ #category : #tests }
SAObservationPrimitiveTest >> testString [
	| item obj |
	obj := 'Hello World!'.
	item := obj
		        smallAmpAcceptSerializerVisitor:
		        SAObjectObserversSerializer new
		        atDepth: 0.
	self assert: item class equals: SAObservationPrimitive.
	self assert: item theClass equals: ByteString.
	self assert: item theValue equals: 'Hello World!'.
]
