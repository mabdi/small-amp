"
A SAASTHelperTest is a test class for testing the behavior of SAASTHelper
"
Class {
	#name : #SAASTHelperTest,
	#superclass : #TestCase,
	#category : #'Amplification-Tests-Helpers'
}

{ #category : #test }
SAASTHelperTest >> testBuildTestClassAndRun [
	| result methods testMethods |
	testMethods := FakeTestcase methods select: [ :each | 
		               each selector beginsWith: 'test' ].
	methods := testMethods collect: [ :atestMethod | 
		           atestMethod sourceCode ].
	result := SAASTHelper new
		          buildTestClassWith: methods
		          using: FakeTestcase.
	self deny:
		(result methods detect: [ :mtd | mtd selector = #setUp ]) isNil.
	self assert: result testSelectors size equals: methods size.
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
	self assert: r equals: 'testWithdraw_1_1
	| b tmp_ZISDO00DGz1 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp_ZISDO00DGz1 := b deposit: 102.
	self assert: tmp_ZISDO00DGz1 balance equals: 102.
	b withdraw: 30.
	self assert: b balance equals: 72'
]
