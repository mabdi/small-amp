"
A SAAssertTransformTest is a test class for testing the behavior of SAAssertTransform
"
Class {
	#name : #SAAssertTransformTest,
	#superclass : #TestCase,
	#category : #'Amplification-Tests-Helpers'
}

{ #category : #accessing }
SAAssertTransformTest >> astHelper [
	^ SAASTHelper new
]

{ #category : #tests }
SAAssertTransformTest >> testGetAllPatterns [
	| anAssertTransform allPatterns |
	anAssertTransform := SAAssertTransform new.
	allPatterns := anAssertTransform getAllPatterns.
	self assert: allPatterns class equals: OrderedCollection.
	self assert: allPatterns size equals: 26.
	allPatterns do: [ :item | self assert: item class equals: Association ]
]

{ #category : #tests }
SAAssertTransformTest >> testRemoveAllAsserts [
	| methodAST sourceCode expectingCode expectingAST |
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
		with: 2.'.
	methodAST := self astHelper parsedMethodFrom: sourceCode.
	expectingAST := self astHelper parsedMethodFrom: expectingCode.
	methodAST := SAAssertTransform removeAllAsserts: methodAST.
	methodAST := self astHelper parsedMethodFrom: methodAST formattedCode.
	self assert: methodAST dump equals: expectingAST dump
]

{ #category : #tests }
SAAssertTransformTest >> testTransformAllAsserts [
	| methodAST sourceCode expectingCode expectingAST |
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
	expectingAST := self astHelper parsedMethodFrom: expectingCode.
	methodAST := SAAssertTransform transformAllAsserts: methodAST.
	methodAST := self astHelper parsedMethodFrom: methodAST formattedCode.
	self assert: methodAST dump equals: expectingAST dump
]
