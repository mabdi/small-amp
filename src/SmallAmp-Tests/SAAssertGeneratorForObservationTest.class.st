"
A SAAssertGeneratorForObservationTest is a test class for testing the behavior of SAAssertGeneratorForObservation
"
Class {
	#name : #SAAssertGeneratorForObservationTest,
	#superclass : #TestCase,
	#instVars : [
		'assertGenerator'
	],
	#category : #'SmallAmp-Tests-Helpers'
}

{ #category : #'as yet unclassified' }
SAAssertGeneratorForObservationTest >> getASerializer [
	^ SAObjectObserversSerializer new
]

{ #category : #running }
SAAssertGeneratorForObservationTest >> setUp [
	assertGenerator := SAAssertGeneratorForObservation new
]

{ #category : #test }
SAAssertGeneratorForObservationTest >> testBuildAssertionCollectionEmpty [
	| arr item assertions |
	arr := Array new.
	item := arr
		        smallAmpAcceptSerializerVisitor:
		        self getASerializer
		        atDepth: 0.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 2.
	self
		assert: (assertions at: 1) formattedCode
		equals:
		'self assert: foo class equals: Array description: ''smallAmp'''.
	self
		assert: (assertions at: 2) formattedCode
		equals: 'self assertEmpty: foo description: ''smallAmp'''
]

{ #category : #test }
SAAssertGeneratorForObservationTest >> testBuildAssertionCollectionSize [
	| arr item assertions |
	arr := Array with: 10 with: 20 with: 30.
	item := arr
		        smallAmpAcceptSerializerVisitor:
		        self getASerializer
		        atDepth: 0.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 3.
	self
		assert: (assertions at: 1) formattedCode
		equals:
		'self assert: foo class equals: Array description: ''smallAmp'''.
	self
		assert: (assertions at: 2) formattedCode
		equals: 'self assert: foo size equals: 3 description: ''smallAmp'''.
	self
		assert: (assertions at: 3) formattedCode
		equals:
		'self assert: foo equals: #( 10 20 30 ) description: ''smallAmp'''
]

{ #category : #test }
SAAssertGeneratorForObservationTest >> testBuildAssertionCollectionValuesMax [
	| arr item assertions |
	arr := (1 to: 100) asArray.
	item := arr
		        smallAmpAcceptSerializerVisitor:
		        self getASerializer
		        atDepth: 0.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 2.
	self
		assert: (assertions at: 1) formattedCode
		equals:
		'self assert: foo class equals: Array description: ''smallAmp'''.
	self
		assert: (assertions at: 2) formattedCode
		equals:
		'self assert: foo size equals: 100 description: ''smallAmp'''
]

{ #category : #test }
SAAssertGeneratorForObservationTest >> testBuildAssertionCollectionValuesNonPrimitive [
	| arr item assertions |
	arr := Array with: 10 with: 20 with: 30 @ 1.
	item := arr
		        smallAmpAcceptSerializerVisitor:
		        self getASerializer
		        atDepth: 0.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 14.
	self
		assert: (assertions at: 1) formattedCode
		equals:
		'self assert: foo class equals: Array description: ''smallAmp'''.
	self
		assert: (assertions at: 2) formattedCode
		equals: 'self assert: foo size equals: 3 description: ''smallAmp'''.
	self assert: (assertions at: 3) formattedCode equals: 'self
	assert: (foo at: 1) class
	equals: SmallInteger
	description: ''smallAmp'''.
	self
		assert: (assertions at: 4) formattedCode
		equals:
		'self assert: foo at: 1 equals: 10 description: ''smallAmp'''.
	self assert: (assertions at: 5) formattedCode equals: 'self
	assert: (foo at: 2) class
	equals: SmallInteger
	description: ''smallAmp'''.
	self
		assert: (assertions at: 6) formattedCode
		equals:
		'self assert: foo at: 2 equals: 20 description: ''smallAmp'''.
	self
		assert: (assertions at: 7) formattedCode
		equals: 'self deny: (foo at: 3) isZero description: ''smallAmp'''.
	self assert: (assertions at: 8) formattedCode equals: 'self
	assert: (foo at: 3) y class
	equals: SmallInteger
	description: ''smallAmp'''.
	self
		assert: (assertions at: 9) formattedCode
		equals:
		'self assert: (foo at: 3) y equals: 1 description: ''smallAmp'''.
	self
		assert: (assertions at: 10) formattedCode
		equals:
		'self deny: (foo at: 3) isFloatPoint description: ''smallAmp'''.
	self
		assert: (assertions at: 11) formattedCode
		equals:
		'self assert: (foo at: 3) isIntegerPoint description: ''smallAmp'''.
	self assert: (assertions at: 12) formattedCode equals: 'self
	assert: (foo at: 3) x class
	equals: SmallInteger
	description: ''smallAmp'''.
	self
		assert: (assertions at: 13) formattedCode
		equals:
		'self assert: (foo at: 3) x equals: 30 description: ''smallAmp'''.
	self
		assert: (assertions at: 14) formattedCode
		equals: 'self assert: (foo at: 3) isPoint description: ''smallAmp'''
]

{ #category : #tests }
SAAssertGeneratorForObservationTest >> testBuildAssertionForError [
	| item assertions |
	item := SAObservationError forError: OutOfMemory.
	assertions := item buildAssertions: assertGenerator.
	self
		assert: (assertions at: 1) formattedCode
		equals:
		'self should: fake raise: OutOfMemory description: ''smallAmp'''
]

{ #category : #tests }
SAAssertGeneratorForObservationTest >> testBuildAssertionForTimeout [
	| item assertions |
	item := SAObservationTimeout forTimeout: 125.
	assertions := item buildAssertions: assertGenerator.
	self assert: (assertions at: 1) formattedCode equals: 'self
	should: fake
	takeMoreThan: (Duration milliSeconds: 125)
	description: ''smallAmp'''
]

{ #category : #test }
SAAssertGeneratorForObservationTest >> testBuildAssertionPrimitiveCollectionValues [
	| arr item assertions |
	arr := Array with: 10 with: 20 with: 30.
	item := arr
		        smallAmpAcceptSerializerVisitor:
		        self getASerializer
		        atDepth: 0.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 3.
	self
		assert: (assertions at: 1) formattedCode
		equals:
		'self assert: foo class equals: Array description: ''smallAmp'''.
	self
		assert: (assertions at: 2) formattedCode
		equals: 'self assert: foo size equals: 3 description: ''smallAmp'''.
	self
		assert: (assertions at: 3) formattedCode
		equals:
		'self assert: foo equals: #( 10 20 30 ) description: ''smallAmp'''
]

{ #category : #test }
SAAssertGeneratorForObservationTest >> testBuildAssertionSize [
	| arr item assertions |
	arr := Array with: 10 with: 20 with: 30.
	item := arr
		        smallAmpAcceptSerializerVisitor:
		        self getASerializer
		        atDepth: 0.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 3.
	self
		assert: (assertions at: 1) formattedCode
		equals:
		'self assert: foo class equals: Array description: ''smallAmp'''.
	self
		assert: (assertions at: 2) formattedCode
		equals: 'self assert: foo size equals: 3 description: ''smallAmp'''.
	self
		assert: (assertions at: 3) formattedCode
		equals:
		'self assert: foo equals: #( 10 20 30 ) description: ''smallAmp'''
]

{ #category : #tests }
SAAssertGeneratorForObservationTest >> testBuildAssertionType [
	| item assertions |
	item := SAObservationPrimitive newForClass: SmallInteger values: 1 atDepth:1.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self
		assert: (assertions at: 1) formattedCode
		equals:
		'self assert: foo class equals: SmallInteger description: ''smallAmp'''
]

{ #category : #test }
SAAssertGeneratorForObservationTest >> testBuildAssertionValue [
	| item assertions |
	item := SAObservationPrimitive newFor: 10 atDepth: 1 .
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 2.
	self
		assert: (assertions at: 1) formattedCode
		equals:
		'self assert: foo class equals: SmallInteger description: ''smallAmp'''.
	self
		assert: (assertions at: 2) formattedCode
		equals: 'self assert: foo equals: 10 description: ''smallAmp'''
]

{ #category : #test }
SAAssertGeneratorForObservationTest >> testBuildAssertionValueFalse [
	| item assertions |
	item := SAObservationFalse newAtDepth: 1.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 1.
	self
		assert: (assertions at: 1) formattedCode
		equals: 'self deny: foo description: ''smallAmp'''
]

{ #category : #test }
SAAssertGeneratorForObservationTest >> testBuildAssertionValueFlaky [
	| item assertions |
	item := SAObservationPrimitive newFor: 10 atDepth: 1.
	item name: 'foo'.
	item isFlaky: true.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 1.
	self
		assert: (assertions at: 1) formattedCode
		equals:
		'self assert: foo class equals: SmallInteger description: ''smallAmp'''
]

{ #category : #test }
SAAssertGeneratorForObservationTest >> testBuildAssertionValueFloat [
	| item assertions |
	item := SAObservationPrimitive newFor: 3.14 atDepth: 1.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 2.
	self
		assert: (assertions at: 1) formattedCode
		equals:
		'self assert: foo class equals: SmallFloat64 description: ''smallAmp'''.
	self
		assert: (assertions at: 2) formattedCode
		equals: 'self assert: foo equals: 3.14 description: ''smallAmp'''
]

{ #category : #test }
SAAssertGeneratorForObservationTest >> testBuildAssertionValueFraction [
	| item assertions |
	item := SAObservationFraction newFor: 1 / 2 atDepth: 1.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 2.
	self
		assert: (assertions at: 1) formattedCode
		equals:
		'self assert: foo class equals: Fraction description: ''smallAmp'''.
	self
		assert: (assertions at: 2) formattedCode
		equals:
		'self assert: foo asString equals: ''(1/2)'' description: ''smallAmp'''
]

{ #category : #test }
SAAssertGeneratorForObservationTest >> testBuildAssertionValueString [
	| item assertions |
	item := SAObservationPrimitive newFor: 'Hello World!' atDepth: 1.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 2.
	self
		assert: (assertions at: 1) formattedCode
		equals:
		'self assert: foo class equals: ByteString description: ''smallAmp'''.
	self
		assert: (assertions at: 2) formattedCode
		equals:
	
		'self assert: foo equals: ''Hello World!'' description: ''smallAmp'''
]

{ #category : #test }
SAAssertGeneratorForObservationTest >> testBuildAssertionValueTrue [
	| item assertions |
	item := SAObservationTrue newAtDepth: 1.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 1.
	self
		assert: (assertions at: 1) formattedCode
		equals: 'self assert: foo description: ''smallAmp'''
]

{ #category : #tests }
SAAssertGeneratorForObservationTest >> testBuildAssertions [
	| item assertions |
	item := SAObservationError forError: OutOfMemory.
	assertions:= (item buildAssertions: assertGenerator).
	self assert: assertions class equals: OrderedCollection.
	self deny: assertions isEmpty
]

{ #category : #tests }
SAAssertGeneratorForObservationTest >> testBuildAssertionsTimeout [
	| item assertions |
	item := SAObservationTimeout forTimeout: 125.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions class equals: OrderedCollection.
	self deny: assertions isEmpty
]
