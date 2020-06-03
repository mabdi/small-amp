"
A SAASTHelperTest is a test class for testing the behavior of SAASTHelper
"
Class {
	#name : #SAASTHelperTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Helpers'
}

{ #category : #test }
SAASTHelperTest >> testAddCommentToMethod [
	| h src2 |
	h := SAASTHelper new.
	src2 := h addComment: 'some comments is here' toMethod: 'foo x:=1'.
	self assert: src2 equals: (RBParser parseMethod: 'foo "some comments is here" x:=1') formattedCode 
]

{ #category : #test }
SAASTHelperTest >> testBuildTestClassAndRun [
	| result methods testMethods |
	testMethods := SAAssertTransformTest methods
		select: [ :each | each selector beginsWith: 'test' ].
	methods := testMethods
		collect: [ :atestMethod | atestMethod sourceCode ].
	result := SAASTHelper new
		buildTestClassWith: methods allButFirst
		using: SAAssertTransformTest.
	self assert: result superclass equals: SAAssertTransformTest.
	self deny: (result selectors includes: testMethods first selector).
	SAASTHelper new removeClass: result source: self class name
]

{ #category : #test }
SAASTHelperTest >> testCleanUp [
	| s r |
	s := 'testWithdraw_1_1
	| b tmp_ZISDO00DGz1 tmp_9nbUP3optD2 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp_ZISDO00DGz1 := b deposit: 102.
	self assert: tmp_ZISDO00DGz1 balance equals: 102.
	tmp_9nbUP3optD2 := b withdraw: 30.
	self assert: b balance equals: 72'.
	r := SAASTHelper new cleanUp: s.
	self assertMethodSourceCode: r equals: 'testWithdraw_1_1
	| b tmp_ZISDO00DGz1 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp_ZISDO00DGz1 := b deposit: 102.
	self assert: tmp_ZISDO00DGz1 balance equals: 102.
	b withdraw: 30.
	self assert: b balance equals: 72'
]

{ #category : #test }
SAASTHelperTest >> testOldBuildTestClassAndRun [
	| result methods testMethods |
	testMethods := SAAssertTransformTest methods
		select: [ :each | each selector beginsWith: 'test' ].
	methods := testMethods
		collect: [ :atestMethod | atestMethod sourceCode ].
	result := SAASTHelper new
		old_buildTestClassWith: methods
		using: SAAssertTransformTest.
	self
		deny: (result methods detect: [ :mtd | mtd selector = #setUp ]) isNil.
	self
		deny: (result methods detect: [ :mtd | mtd selector = #astHelper ]) isNil.
	self assert: result testSelectors size equals: methods size.
	SAASTHelper new removeClass: result source: self class name
]
