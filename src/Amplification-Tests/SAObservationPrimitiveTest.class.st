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

{ #category : #test }
SAObservationPrimitiveTest >> testBuildAssertionValue [
	| item |
	item := SAObservationPrimitive newForNumber: 10.
	item name: 'foo'.
	self
		assert: item buildAssertionValue formattedCode
		equals: 'self assert: foo equals: 10 description: ''smallAmp'''
]

{ #category : #test }
SAObservationPrimitiveTest >> testBuildAssertionValueBoolean [
	| item |
	self flag: #TODO. "use assert and deny instead of assert:equal:"
	item := SAObservationPrimitive newForFalse.
	item name: 'foo'.
	self
		assert: item buildAssertionValue formattedCode
		equals: 'self assert: foo equals: false description: ''smallAmp'''
]

{ #category : #test }
SAObservationPrimitiveTest >> testBuildAssertionValueFlaky [
	| item |
	item := SAObservationPrimitive newForNumber: 10.
	item isFlaky: true.
	self assert: item buildAssertionValue isNil
]

{ #category : #test }
SAObservationPrimitiveTest >> testBuildAssertionValueFloat [
	| item |
	item := SAObservationPrimitive newForNumber: 3.14.
	item name: 'foo'.
	self
		assert: item buildAssertionValue formattedCode
		equals: 'self assert: foo equals: 3.14 description: ''smallAmp'''
]

{ #category : #test }
SAObservationPrimitiveTest >> testBuildAssertionValueFraction [
	| item |
	item := SAObservationPrimitive newForNumber: 1/2.
	item name: 'foo'.
	self
		assert: item buildAssertionValue formattedCode
		equals: 'self assert: foo asString equals: ''(1/2)'' description: ''smallAmp'''
]

{ #category : #test }
SAObservationPrimitiveTest >> testBuildAssertionValueString [
	| item |
	item := SAObservationPrimitive
		        newForString: 'Hello World!'.
	item name: 'foo'.
	self
		assert: item buildAssertionValue formattedCode
		equals:
		'self assert: foo equals: ''Hello World!'' description: ''smallAmp'''
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
SAObservationPrimitiveTest >> testCheckFlaky [
	| item1 item2 p1 p2 |
	p1 := 10.
	p2 := 11.
	item1 := p1
		         smallAmpAcceptSerializerVisitor:
		         SAObjectObserversSerializer new
		         atDepth: 0.
	item2 := p2
		         smallAmpAcceptSerializerVisitor:
		         SAObjectObserversSerializer new
		         atDepth: 0.
	self deny: item1 isFlaky.
	item1 checkFlaky: item2.
	self assert: item1 isFlaky
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
