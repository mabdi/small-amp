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

{ #category : #tests }
SAAssertGeneratorTest >> testAssertObjectState [
	| item assertions |
	item := SAObservationPrimitive newFor: 10 atDepth: 1.
	item name: 'foo'; id: 2; observedBy: #sth.
	assertions := SAAssertGenerator new buildAssertObjectStateFor: item.
	self
		assertSourceCode: assertions formattedCode
		equals: 'self
	assertObjectState: foo
	varName: ''foo''
	id: 2
	type: #sth'
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
	self assert: assertions class equals: OrderedCollection.
	self assert: assertions size equals: 5.
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
		equals: 'self assert: (foo at: 2) equals: 20 @ 10'.
	self
		assertSourceCode: (assertions at: 5) formattedCode
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
	| item assertions obj |
	obj := SATestObject new
		field1: (Array with: 10 with: 20 / 3 with: 30).
	item := obj
		smallAmpAcceptSerializerVisitor: self getASerializer
		atDepth: 0.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 5.
	self
		assertSourceCode: (assertions at: 1) formattedCode
		equals: 'self assert: foo class equals: SATestObject'.
	self
		assertSourceCode: (assertions at: 2) formattedCode
		equals: 'self assert: foo field1 class equals: Array'.
	self
		assertSourceCode: (assertions at: 3) formattedCode
		equals: 'self assert: foo field1 size equals: 3'.
	self
		assertSourceCode: (assertions at: 4) formattedCode
		equals:
			'self
	assert: (foo field1 collect: #asString)
	equals: #(''10'' ''(20/3)'' ''30'')'.
	self
		assertSourceCode: (assertions at: 5) formattedCode
		equals: 'self assert: foo field2 isNil'
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
	self assert: assertions class equals: OrderedCollection.
	self assert: assertions size equals: 5.
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
		equals: 'self assert: (foo at: 3) equals: 30 @ 1'
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
	| className item assertions |
	item := SAObservationBlockClosure newFor: [ :a | a + 1 ] atDepth: 1.
	className := [  ] class name.
	item name: 'foo'.
		assertions := item buildAssertions: assertGenerator.

	self assert: assertions size equals: 2.
	self
		assertSourceCode: (assertions at: 1) formattedCode
		equals: 'self assert: foo class equals: ', className.
	self
		assertSourceCode: (assertions at: 2) formattedCode
		equals: 'self assert: foo sourceNode formattedCode equals: ''[ :a | a + 1 ]'''
]

{ #category : #test }
SAAssertGeneratorTest >> testBuildAssertionsClass [
	| item assertions |
	item := SAObservationClass newFor: SmallAmp atDepth: 1.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions class equals: OrderedCollection.
	self assert: assertions size equals: 1.
	self
		assertSourceCode: (assertions at: 1) formattedCode
		equals: 'self assert: foo equals: SmallAmp'
]

{ #category : #test }
SAAssertGeneratorTest >> testBuildAssertionsDateTimeObservation [
	| item assertions |
	item := SAObservationDateTime
		newFor: (DateAndTime fromUnixTime: 1586554022)
		atDepth: 1.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 1.
	self
		assertSourceCode: (assertions at: 1) formattedCode
		equals: 'self assert: foo asUTC asString equals: ''2020-04-10T21:27:02+00:00'''.
	item isFlaky: true.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions size equals: 1.
	self
		assertSourceCode: (assertions at: 1) formattedCode
		equals: 'self assert: foo class equals: DateAndTime'
]

{ #category : #tests }
SAAssertGeneratorTest >> testBuildAssertionsFractionPoint [
	| item assertions |
	item := 0 @ (5 / 2)
		smallAmpAcceptSerializerVisitor: SAStateSerializer new
		atDepth: 1.
	item name: 'foo'.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions class equals: OrderedCollection.
	self assert: assertions size equals: 1.
	self
		assertSourceCode: (assertions at: 1) formattedCode
		equals: 'self assert: foo equals: (0 @ (5 / 2))'
]

{ #category : #tests }
SAAssertGeneratorTest >> testBuildAssertionsTimeout [
	| item assertions |
	self skip: 'I dont generate timeout at the moment'
	"
	item := SAObservationTimeout forTimeout: 125.
	assertions := item buildAssertions: assertGenerator.
	self assert: assertions class equals: OrderedCollection.
	self deny: assertions isEmpty.
	self assert: assertions first selector equals: #should:takeMoreThan:"
]
