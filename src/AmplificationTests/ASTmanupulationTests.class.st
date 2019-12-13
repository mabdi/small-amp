Class {
	#name : #ASTmanupulationTests,
	#superclass : #TestCase,
	#instVars : [
		'testMethods'
	],
	#category : #AmplificationTests
}

{ #category : #running }
ASTmanupulationTests >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	super setUp.
	testMethods := (FakeTestcase methods
		select: [ :each | each selector beginsWith: 'test' ]).
]

{ #category : #tests }
ASTmanupulationTests >> testBuildTestClassAndRun [
	| result methods |
	methods := testMethods
		collect: [ :atestMethod | atestMethod sourceCode ].
	result := SAASTHelper new
		buildTestClassWith: methods
		using: FakeTestcase.
	self
		deny: (result methods detect: [ :mtd | mtd selector = #setUp ]) isNil.
	self assert: result testSelectors size equals: methods size.
	SAASTHelper new removeClass: result source: self class name.
]

{ #category : #tests }
ASTmanupulationTests >> testCleanUpVisitor [
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

{ #category : #tests }
ASTmanupulationTests >> testConvertAllToAssert [
	| result |
	result := testMethods collect: [ :each | 
		          SAASTHelper new convertAllToAssert: each ].
	self assert: (result allSatisfy: [ :src | 
			 ((SAASTHelper new stripString: src) findString:
				  'self deny:' onlyLetters) == 0 ]).
	self assert: (result allSatisfy: [ :src | 
			 ((SAASTHelper new stripString: src) findString:
				  'self should:' onlyLetters) == 0 ])
]

{ #category : #tests }
ASTmanupulationTests >> testExtractMethodName [
	{UUID.
	UUIDGenerator.
	OrderedCollection.
	FakeTestcase}
		do: [ :class | 
			class methods
				do: [ :method | 
					self
						assert: (method selector asString)
						equals:
							(SAASTHelper new extractMethodName: method sourceCode)
								 ] ]
]

{ #category : #tests }
ASTmanupulationTests >> testMethodRename [
	{UUID.
	UUIDGenerator.
	OrderedCollection.
	FakeTestcase}
		do: [ :class | 
			(class methods
				select: [ :mtd | (mtd selector asString at: 1) isLetter ])
				do: [ :method | 
					{'1' . 'new' . '_old'}
						do: [ :post | 
							self
								assert: ((method selector asString splitOn: $:) at: 1) , post
								equals:
									(SAASTHelper new
										extractMethodName:
											(((SAASTHelper new
												renameMethodName: method sourceCode
												append: post)selector asString splitOn: $:)at: 1)) ] ] ]
]

{ #category : #tests }
ASTmanupulationTests >> testRemoveAssertions [
	| result |
	result := testMethods collect: [ :each | 
		          SAASTHelper new removeAssertions: each sourceCode ].
	self assert: (result allSatisfy: [ :src | 
			 ((SAASTHelper new stripString: src) findString:
				  'self assert:' onlyLetters) == 0 ]).
	self assert: (result allSatisfy: [ :src | 
			 ((SAASTHelper new stripString: src) findString:
				  'self deny:' onlyLetters) == 0 ]).
	self assert: (result allSatisfy: [ :src | 
			 ((SAASTHelper new stripString: src) findString:
				  'self should:' onlyLetters) == 0 ])
]
