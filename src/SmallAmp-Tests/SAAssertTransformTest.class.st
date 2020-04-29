"
A SAAssertTransformTest is a test class for testing the behavior of SAAssertTransform
"
Class {
	#name : #SAAssertTransformTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Helpers'
}

{ #category : #accessing }
SAAssertTransformTest >> astHelper [
	^ SAASTHelper new
]

{ #category : #running }
SAAssertTransformTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	super setUp
	
]

{ #category : #tests }
SAAssertTransformTest >> testGetAllPatterns [
	| anAssertTransform allPatterns |
	anAssertTransform := SAAssertTransform new.
	allPatterns := anAssertTransform getAllPatterns.
	self assert: allPatterns class equals: OrderedCollection.
	self assert: allPatterns size equals: 27.
	allPatterns
		do: [ :item | self assert: item class equals: Association ]
]

{ #category : #test }
SAAssertTransformTest >> testGetReduceOraclePatterns [
	| anAssertTransform allPatterns |
	anAssertTransform := SAAssertTransform new.
	allPatterns := anAssertTransform getReduceOraclePatterns.
	self assert: allPatterns class equals: OrderedCollection.
	self assert: allPatterns size equals: 21.
	allPatterns
		do: [ :item | self assert: item class equals: Association ]
]

{ #category : #test }
SAAssertTransformTest >> testNumberOfAssertionsIn [
	| sourceCode methodAST |
	sourceCode := 'fooMethod
	| tmp1 |
	a := foo bar.
	tmp1 := Array
		with: 1;
		with: 2.
	self assert: tmp1 isNotEmpty.self should: [tmp1 isNotEmpty].self deny: tmp1 isNotEmpty'.
	methodAST := self astHelper parsedMethodFrom: sourceCode.
	self
		assert: (SAAssertTransform new numberOfAssertionsIn: methodAST)
		equals: 3
]

{ #category : #test }
SAAssertTransformTest >> testNumberOfAssertionsIn2 [
	| sourceCode methodAST |
	sourceCode := 'fooMethod
	| tmp1 |
	a := foo bar.
	tmp1 := Array
		with: 1;
		with: 2.
	self assert: tmp1 isNotEmpty; should: [tmp1 isNotEmpty]; deny: tmp1 isNotEmpty'.
	methodAST := self astHelper parsedMethodFrom: sourceCode.
	self
		assert: (SAAssertTransform new numberOfAssertionsIn: methodAST)
		equals: 3
]

{ #category : #tests }
SAAssertTransformTest >> testRemoveAllAsserts [
	| methodAST sourceCode expectingCode |
	sourceCode := 'fooMethod
	| tmp1 |
	a := foo bar.
	tmp1 := Array
		with: 1;
		with: 2.
	self assert: tmp1 isNotEmpty'.
	expectingCode := 'fooMethod
	| tmp1 |
	a := foo bar.
	tmp1 := Array
		with: 1;
		with: 2.'.
	methodAST := self astHelper parsedMethodFrom: sourceCode.
	methodAST := SAAssertTransform removeAllAsserts: methodAST.
	self assertMethodSourceCode: methodAST formattedCode equals: expectingCode
]

{ #category : #tests }
SAAssertTransformTest >> testRemoveAssertEmpty [
	| methodAST sourceCode expectingCode |
	sourceCode := 'fooMethod
	| tmp1 |
	a := foo bar.
	tmp1 := Array new.
	self assertEmpty: tmp1'.
	expectingCode := 'fooMethod
	| tmp1 |
	a := foo bar.
	tmp1 := Array new.'.
	methodAST := self astHelper parsedMethodFrom: sourceCode.
	methodAST := SAAssertTransform removeAllAsserts: methodAST.
	self
		assertMethodSourceCode: methodAST formattedCode
		equals: expectingCode
]

{ #category : #tests }
SAAssertTransformTest >> testTransformAllAsserts [
	| methodAST sourceCode expectingCode  |
	sourceCode := 'foo
	| tmp1 |
	a := foo bar.
	tmp1 := Array
		with: 1;
		with: 2.
	self assert: tmp1 isNotEmpty'.
	expectingCode := 'foo
	| tmp1 |
	a := foo bar.
	tmp1 := Array
		with: 1;
		with: 2.
	tmp1 isNotEmpty value'.
	methodAST := self astHelper parsedMethodFrom: sourceCode.
	methodAST := SAAssertTransform transformAllAsserts: methodAST.
	self
		assertMethodSourceCode: methodAST formattedCode
		equals: expectingCode
]
