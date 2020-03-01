"
A SAAssertGeneratorForObservationTest is a test class for testing the behavior of SAAssertGeneratorForObservation
"
Class {
	#name : #SAAssertGeneratorTest,
	#superclass : #TestCase,
	#instVars : [
		'assertGenerator'
	],
	#category : #'SmallAmp-Tests-Helpers'
}

{ #category : #'as yet unclassified' }
SAAssertGeneratorTest >> getASerializer [
	^ SAStateSerializer new
]

{ #category : #running }
SAAssertGeneratorTest >> setUp [
	assertGenerator := SAAssertGenerator new
]

{ #category : #test }
SAAssertGeneratorTest >> testBuildAssertionCollectionAt [
	| arr item assertions |
	arr := Array with: 10 with: 20 @ 10 with: 30.
	item := arr
		smallAmpAcceptSerializerVisitor: self getASerializer
		atDepth: 0.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 10.
	self
		assertSourceCode: (assertions at: 1) formattedCode
		equals: 'self assert: foo class equals: Array'.
	self
		assertSourceCode: (assertions at: 2) formattedCode
		equals: 'self assert: foo size equals: 3'.
	self
		assertSourceCode: (assertions at: 3) formattedCode
		equals: 'self assert: (foo at: 1) equals: 10'.
	self
		assertSourceCode: (assertions at: 4) formattedCode
		equals: 'self deny: (foo at: 2) isZero'.
	self
		assertSourceCode: (assertions at: 5) formattedCode
		equals: 'self assert: (foo at: 2) y equals: 10'.
	self
		assertSourceCode: (assertions at: 6) formattedCode
		equals: 'self deny: (foo at: 2) isFloatPoint'.
	self
		assertSourceCode: (assertions at: 7) formattedCode
		equals: 'self assert: (foo at: 2) isIntegerPoint'.
	self
		assertSourceCode: (assertions at: 8) formattedCode
		equals: 'self assert: (foo at: 2) x equals: 20'.
	self
		assertSourceCode: (assertions at: 9) formattedCode
		equals: 'self assert: (foo at: 2) isPoint'.
	self
		assertSourceCode: (assertions at: 10) formattedCode
		equals: 'self assert: (foo at: 3) equals: 30'
]

{ #category : #test }
SAAssertGeneratorTest >> testBuildAssertionCollectionEmpty [
	| arr item assertions |
	arr := Array new.
	item := arr
		        smallAmpAcceptSerializerVisitor: self getASerializer
		        atDepth: 0.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 2.
	self
		assertSourceCode: (assertions at: 1) formattedCode
		equals: 'self assert: foo class equals: Array'.
	self
		assertSourceCode: (assertions at: 2) formattedCode
		equals: 'self assertEmpty: foo'
]

{ #category : #test }
SAAssertGeneratorTest >> testBuildAssertionCollectionObject [
	|  item assertions obj |
	obj := TestObject new field1: (Array with: 10 with: 20 /3 with: 30).
	
	item := obj
		smallAmpAcceptSerializerVisitor: self getASerializer
		atDepth: 0.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 4.
	self
		assertSourceCode: (assertions at: 1) formattedCode
		equals: 'self assert: foo field1 class equals: Array'.
	self
		assertSourceCode: (assertions at: 2) formattedCode
		equals: 'self assert: foo field1 size equals: 3'.
	self
		assertSourceCode: (assertions at: 3) formattedCode
		equals: 'self
	assert: (foo field1 collect: #asString)
	equals: #(''10'' ''(20/3)'' ''30'')'.
	self
		assertSourceCode: (assertions at: 4) formattedCode
		equals: 'self assert: foo field2 isNil'.
	
]

{ #category : #test }
SAAssertGeneratorTest >> testBuildAssertionCollectionSize [
	| arr item assertions |
	arr := Array with: 10 with: 20 with: 30.
	item := arr
		smallAmpAcceptSerializerVisitor: self getASerializer
		atDepth: 0.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 3.
	self
		assertSourceCode: (assertions at: 1) formattedCode
		equals: 'self assert: foo class equals: Array'.
	self
		assertSourceCode: (assertions at: 2) formattedCode
		equals: 'self assert: foo size equals: 3'.
	self
		assertSourceCode: (assertions at: 3) formattedCode
		equals: 'self assert: foo equals: #( 10 20 30 )'
]

{ #category : #test }
SAAssertGeneratorTest >> testBuildAssertionCollectionValuesMax [
	| arr item assertions |
	arr := (1 to: 100) asArray.
	item := arr
		        smallAmpAcceptSerializerVisitor: self getASerializer
		        atDepth: 0.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 2.
	self
		assertSourceCode: (assertions at: 1) formattedCode
		equals: 'self assert: foo class equals: Array'.
	self
		assertSourceCode: (assertions at: 2) formattedCode
		equals: 'self assert: foo size equals: 100'
]

{ #category : #test }
SAAssertGeneratorTest >> testBuildAssertionCollectionValuesNonPrimitive [
	| arr item assertions |
	arr := Array with: 10 with: 20 with: 30 @ 1.
	item := arr
		        smallAmpAcceptSerializerVisitor: self getASerializer
		        atDepth: 0.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 10.
	self
		assertSourceCode: (assertions at: 1) formattedCode
		equals: 'self assert: foo class equals: Array'.
	self
		assertSourceCode: (assertions at: 2) formattedCode
		equals: 'self assert: foo size equals: 3'.
	self
		assertSourceCode: (assertions at: 3) formattedCode
		equals: 'self assert: (foo at: 1) equals: 10'.
	self
		assertSourceCode: (assertions at: 4) formattedCode
		equals: 'self assert: (foo at: 2) equals: 20'.
	self
		assertSourceCode: (assertions at: 5) formattedCode
		equals: 'self deny: (foo at: 3) isZero'.
	self
		assertSourceCode: (assertions at: 6) formattedCode
		equals: 'self assert: (foo at: 3) y equals: 1'.
	self
		assertSourceCode: (assertions at: 7) formattedCode
		equals: 'self deny: (foo at: 3) isFloatPoint'.
	self
		assertSourceCode: (assertions at: 8) formattedCode
		equals: 'self assert: (foo at: 3) isIntegerPoint'.
	self
		assertSourceCode: (assertions at: 9) formattedCode
		equals: 'self assert: (foo at: 3) x equals: 30'.
	self
		assertSourceCode: (assertions at: 10) formattedCode
		equals: 'self assert: (foo at: 3) isPoint'
]

{ #category : #tests }
SAAssertGeneratorTest >> testBuildAssertionForError [
	| item assertions |
	item := SAObservationError forError: OutOfMemory.
	assertions := item buildAssertions: assertGenerator.
	self
		assertSourceCode: (assertions at: 1) formattedCode
		equals: 'self should: ', SAAssertGenerator blockPlaceHolder , ' raise: OutOfMemory'
]

{ #category : #test }
SAAssertGeneratorTest >> testBuildAssertionPrimitiveCollectionValues [
	| arr item assertions |
	arr := Array with: 10 with: 20 with: 30.
	item := arr
		        smallAmpAcceptSerializerVisitor: self getASerializer
		        atDepth: 0.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 3.
	self
		assertSourceCode: (assertions at: 1) formattedCode
		equals: 'self assert: foo class equals: Array'.
	self
		assertSourceCode: (assertions at: 2) formattedCode
		equals: 'self assert: foo size equals: 3'.
	self
		assertSourceCode: (assertions at: 3) formattedCode
		equals: 'self assert: foo  equals: #( 10 20 30 )'
]

{ #category : #test }
SAAssertGeneratorTest >> testBuildAssertionPrimitiveCollectionValuesAsString [
	| arr item assertions |
	arr := Array with: 10 / 3 with: 20 / 3 with: 30 / 3.
	item := arr
		smallAmpAcceptSerializerVisitor: self getASerializer
		atDepth: 0.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 3.
	self
		assertSourceCode: (assertions at: 1) formattedCode
		equals: 'self assert: foo class equals: Array'.
	self
		assertSourceCode: (assertions at: 2) formattedCode
		equals: 'self assert: foo size equals: 3'.
	self
		assertSourceCode: (assertions at: 3) formattedCode
		equals: 'self assert: (foo collect: #asString) equals: #(''(10/3)'' ''(20/3)'' ''10'')'
]

{ #category : #test }
SAAssertGeneratorTest >> testBuildAssertionPrimitiveOrderCollection [
	| arr item assertions |
	arr := OrderedCollection new.
	arr
		add: 10;
		add: 20;
		add: 30.
	item := arr
		smallAmpAcceptSerializerVisitor: self getASerializer
		atDepth: 0.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 3.
	self
		assertSourceCode: (assertions at: 1) formattedCode
		equals: 'self assert: foo class equals: OrderedCollection'.
	self
		assertSourceCode: (assertions at: 2) formattedCode
		equals: 'self assert: foo size equals: 3'.
	self
		assertSourceCode: (assertions at: 3) formattedCode
		equals: 'self assert: foo asArray equals: #( 10 20 30 )'
]

{ #category : #test }
SAAssertGeneratorTest >> testBuildAssertionSize [
	| arr item assertions |
	arr := Array with: 10 with: 20 with: 30.
	item := arr
		smallAmpAcceptSerializerVisitor: self getASerializer
		atDepth: 0.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 3.
	self
		assertSourceCode: (assertions at: 1) formattedCode
		equals: 'self assert: foo class equals: Array'.
	self
		assertSourceCode: (assertions at: 2) formattedCode
		equals: 'self assert: foo size equals: 3'.
	self
		assertSourceCode: (assertions at: 3) formattedCode
		equals: 'self assert: foo equals: #( 10 20 30 )'
]

{ #category : #tests }
SAAssertGeneratorTest >> testBuildAssertionType [
	| item assertions |
	item := SAObservationPrimitive
		        newForClass: SmallInteger
		        values: 1
		        atDepth: 1.
	item name: 'foo'.
	item isFlaky: true.
	assertions := item buildAssertions: assertGenerator.
	self
		assertSourceCode: (assertions at: 1) formattedCode
		equals: 'self assert: foo class equals: SmallInteger'
]

{ #category : #test }
SAAssertGeneratorTest >> testBuildAssertionValue [
	| item assertions |
	item := SAObservationPrimitive newFor: 10 atDepth: 1.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 1.
	self
		assertSourceCode: (assertions at: 1) formattedCode
		equals: 'self assert: foo equals: 10'
]

{ #category : #test }
SAAssertGeneratorTest >> testBuildAssertionValueFalse [
	| item assertions |
	item := SAObservationFalse newAtDepth: 1.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 1.
	self
		assertSourceCode: (assertions at: 1) formattedCode
		equals: 'self deny: foo'
]

{ #category : #test }
SAAssertGeneratorTest >> testBuildAssertionValueFlaky [
	| item assertions |
	item := SAObservationPrimitive newFor: 10 atDepth: 1.
	item name: 'foo'.
	item isFlaky: true.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 1.
	self
		assertSourceCode: (assertions at: 1) formattedCode
		equals: 'self assert: foo class equals: SmallInteger'
]

{ #category : #test }
SAAssertGeneratorTest >> testBuildAssertionValueFloat [
	| item assertions |
	item := SAObservationPrimitive newFor: 3.14 atDepth: 1.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 1.
	self
		assertSourceCode: (assertions at: 1) formattedCode
		equals: 'self assert: foo equals: 3.14'
]

{ #category : #test }
SAAssertGeneratorTest >> testBuildAssertionValueFraction [
	| item assertions |
	item := SAObservationFraction newFor: 1 / 2 atDepth: 1.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 2.
	self
		assertSourceCode: (assertions at: 1) formattedCode
		equals: 'self assert: foo class equals: Fraction'.
	self
		assertSourceCode: (assertions at: 2) formattedCode
		equals: 'self assert: foo asString equals: ''(1/2)'''
]

{ #category : #test }
SAAssertGeneratorTest >> testBuildAssertionValueString [
	| item assertions |
	item := SAObservationPrimitive newFor: 'Hello World!' atDepth: 1.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 1.
	self
		assertSourceCode: (assertions at: 1) formattedCode
		equals: 'self assert: foo equals: ''Hello World!'''
]

{ #category : #test }
SAAssertGeneratorTest >> testBuildAssertionValueTrue [
	| item assertions |
	item := SAObservationTrue newAtDepth: 1.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 1.
	self
		assertSourceCode: (assertions at: 1) formattedCode
		equals: 'self assert: foo'
]

{ #category : #tests }
SAAssertGeneratorTest >> testBuildAssertions [
	| item assertions |
	item := SAObservationError forError: OutOfMemory.
	assertions:= (item buildAssertions: assertGenerator).
	self assert: assertions class equals: OrderedCollection.
	self deny: assertions isEmpty
]

{ #category : #test }
SAAssertGeneratorTest >> testBuildAssertionsBlockClosureObservation [
	| item assertions |
	item := SAObservationBlockClosure newFor: [ :a | a + 1 ] atDepth: 1.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 2.
	self
		assertSourceCode: (assertions at: 1) formattedCode
		equals: 'self assert: foo class equals: BlockClosure'.
	self
		assertSourceCode: (assertions at: 2) formattedCode
		equals: 'self assert: foo asString equals: ''[ :a | a + 1 ]'''
]

{ #category : #tests }
SAAssertGeneratorTest >> testBuildAssertionsTimeout [
	| item assertions |
	item := SAObservationTimeout forTimeout: 125.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions class equals: OrderedCollection.
	self deny: assertions isEmpty.
	self assert: (assertions first selector) equals: #should:takeMoreThan: 
	
]
