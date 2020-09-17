"
A SAInstantiationTransplanterTest is a test class for testing the behavior of SAInstantiationTransplanter
"
Class {
	#name : #SAInstantiationTransplanterTest,
	#superclass : #TestCase,
	#instVars : [
		'config',
		'transplanter',
		'cls'
	],
	#category : #'SmallAmp-Tests-Core'
}

{ #category : #'as yet unclassified' }
SAInstantiationTransplanterTest >> genClass1 [
	cls := SAASTHelper new
		makeClassFrom:
			{'testO0 | s0 | 1+1. s0 := ''Hi''' . 'testO1 | s1 | s1 := 1 asString'.
			'testO2 | s2 | 1 + 1. s2 := String streamContents: [ :stream |  stream nextPutAll: ''Foo'';lf;nextPutAll: ''Bar'' ]. 4+ 1. ''ss'' size '.
			'testO3 | s1 | s1 := '':'' join: { ''Foo''. ''Bar'' } '}
		instanceVars: ''.
]

{ #category : #'as yet unclassified' }
SAInstantiationTransplanterTest >> genClass2 [
	cls := SAASTHelper new
		makeClassFrom:
			{'setUp z := ''voila''. x:= 10'.
			'testO0 | s0 | 1+x. s0 := ''Hi'''.
			'testO3 '.
			'testO4 | s0 | 1+x. s0 := z'.
			'testO1 | s1 | s1 := x asString'.
			'testO5 | s1 c | c := 15. s1 := c asString'.
			'testO2 | s2 | 1 + 1. s2 := String streamContents: [ :stream |  stream nextPutAll: ''Foo'';lf;nextPutAll: ''Bar'' ]. 4+ 1. ''ss'' size '.
			}
		instanceVars: 'x z'
]

{ #category : #'as yet unclassified' }
SAInstantiationTransplanterTest >> genClass3 [
	cls := SAASTHelper new
		makeClassFrom:
			{'setUp s := FakeSmallBank new. s deposit: 10'.
			'testO0 | s0 | s0 := ''Hi''' . 'testO1 | s2 t | t := FakeSmallBank new. t deposit: 34. s2 := String streamContents: [ :stream |  stream nextPutAll: t balance asString;lf;nextPutAll: ''Bar'' ]. 4+ 1. ''ss'' size '.
			'testO2 | s2 | s2 := String streamContents: [ :stream |  stream nextPutAll: s balance asString;lf;nextPutAll: ''Foo'' ]'}
		instanceVars: 's'
]

{ #category : #running }
SAInstantiationTransplanterTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	config := SAConfig default.
	transplanter := SAInstantiationTransplanter 
		initializeWith: config.
	
]

{ #category : #sorting }
SAInstantiationTransplanterTest >> sortResult: res [
	| codes |
	codes := res
		collect: [ :r | 
			r testMethod
				copyWithRegex: 'testO\d_T(\d+)'
				matchesReplacedWith: 'test' ].
	codes sort.
	^ codes
]

{ #category : #running }
SAInstantiationTransplanterTest >> tearDown [ 
	cls ifNotNil: [
	cls removeFromSystem].
]

{ #category : #tests }
SAInstantiationTransplanterTest >> testCase1 [
	| aSAObjectInstantiationExtractor item res codes |
	self genClass1.
	aSAObjectInstantiationExtractor := SAObjectInstantiationExtractor new.
	aSAObjectInstantiationExtractor testClass: cls.
	aSAObjectInstantiationExtractor run.
	transplanter
		instantiationPatterns: aSAObjectInstantiationExtractor patterns.
	item := SATestMethod
		with: (cls >> #testO1) sourceCode
		class: cls
		targets: {ByteString}.
	res := item inputAmplifyBy: transplanter.
	codes := self sortResult: res.
	self assert: codes size equals: 3.
	self
		assertMethodSourceCode: codes first
		equals:
			'test
	| s1 |
	s1 := '':'' join: {''Foo'' . ''Bar''}'.
	self
		assertMethodSourceCode: codes second
		equals:
			'test
	| s1 |
	s1 := 1 asString'.
	self
		assertMethodSourceCode: codes third
		equals:
			'test
	| s1 |
	s1 := String
		streamContents: [ :stream | 
			stream
				nextPutAll: ''Foo'';
				lf;
				nextPutAll: ''Bar'' ]'.
	item := SATestMethod
		with: (cls >> #testO0) sourceCode
		class: cls
		targets: {ByteString}.
	res := item inputAmplifyBy: transplanter.
	codes := self sortResult: res.
	self assert: codes size equals: 3.
	self
		assertMethodSourceCode: codes first
		equals:
			'test
	| s0 |
	1 + 1.
	s0 := '':'' join: {''Foo'' . ''Bar''}'.
	item := SATestMethod
		with: (cls >> #testO2) sourceCode
		class: cls
		targets: {ByteString}.
	res := item inputAmplifyBy: transplanter.
	codes := self sortResult: res.
	self assert: codes size equals: 3.
	self
		assertMethodSourceCode: codes first
		equals:
			'test
	| s2 |
	1 + 1.
	s2 := '':'' join: {''Foo'' . ''Bar''}.
	4 + 1.
	''ss'' size'.
]

{ #category : #tests }
SAInstantiationTransplanterTest >> testCase2 [
	| aSAObjectInstantiationExtractor items res codes |
	self genClass2.
	aSAObjectInstantiationExtractor := SAObjectInstantiationExtractor new.
	aSAObjectInstantiationExtractor testClass: cls.
	aSAObjectInstantiationExtractor run.
	transplanter
		instantiationPatterns: aSAObjectInstantiationExtractor patterns.
	items := #(testO0 testO1 testO2 testO3 testO4 testO5)
		collect: [ :sel | 
			SATestMethod
				with: (cls >> sel) sourceCode
				class: cls
				targets: {ByteString} ].
	res := items first inputAmplifyBy: transplanter.
	codes := self sortResult: res.
	self assert: codes size equals: 6.
	self
		assertMethodSourceCode: codes first
		equals:
			'test
	| s0 c |
	1 + x.
	c := 15.
	s0 := c asString'.
	self
		assertMethodSourceCode: codes second
		equals:
			'test
	| s0 c |
	c := 15.
	z := c asString.
	1 + x.
	s0 := ''Hi'''.
	self
		assertMethodSourceCode: codes third
		equals:
			'test
	| s0 |
	1 + x.
	s0 := String
		streamContents: [ :stream | 
			stream
				nextPutAll: ''Foo'';
				lf;
				nextPutAll: ''Bar'' ]'.
	res := items second inputAmplifyBy: transplanter.
	codes := self sortResult: res.
	self assert: codes size equals: 6.
	"String streamContents: [ :x | codes do: [ :c | c storeOn: x . x nextPutAll: '.'].  ]"
	{'test
	| s1 c |
	c := 15.
	s1 := c asString' . 'test
	| s1 c |
	c := 15.
	z := c asString.
	s1 := x asString' . 'test
	| s1 |
	s1 := String
		streamContents: [ :stream | 
			stream
				nextPutAll: ''Foo'';
				lf;
				nextPutAll: ''Bar'' ]' . 'test
	| s1 |
	s1 := x asString' . 'test
	| s1 |
	z := String
		streamContents: [ :stream | 
			stream
				nextPutAll: ''Foo'';
				lf;
				nextPutAll: ''Bar'' ].
	s1 := x asString' . 'test
	| s1 |
	z := x asString.
	s1 := x asString'}
		doWithIndex:
			[ :expected :index | self assertMethodSourceCode: (codes at: index) equals: expected ].
	res := items third inputAmplifyBy: transplanter.
	codes := self sortResult: res.
	self assert: codes size equals: 6.
	{'test
	| s2 c |
	1 + 1.
	c := 15.
	s2 := c asString.
	4 + 1.
	''ss'' size' . 'test
	| s2 c |
	c := 15.
	z := c asString.
	1 + 1.
	s2 := String
		streamContents: [ :stream | 
			stream
				nextPutAll: ''Foo'';
				lf;
				nextPutAll: ''Bar'' ].
	4 + 1.
	''ss'' size' . 'test
	| s2 |
	1 + 1.
	s2 := String
		streamContents: [ :stream | 
			stream
				nextPutAll: ''Foo'';
				lf;
				nextPutAll: ''Bar'' ].
	4 + 1.
	''ss'' size' . 'test
	| s2 |
	1 + 1.
	s2 := x asString.
	4 + 1.
	''ss'' size' . 'test
	| s2 |
	z := String
		streamContents: [ :stream | 
			stream
				nextPutAll: ''Foo'';
				lf;
				nextPutAll: ''Bar'' ].
	1 + 1.
	s2 := String
		streamContents: [ :stream | 
			stream
				nextPutAll: ''Foo'';
				lf;
				nextPutAll: ''Bar'' ].
	4 + 1.
	''ss'' size' . 'test
	| s2 |
	z := x asString.
	1 + 1.
	s2 := String
		streamContents: [ :stream | 
			stream
				nextPutAll: ''Foo'';
				lf;
				nextPutAll: ''Bar'' ].
	4 + 1.
	''ss'' size'}
		doWithIndex:
			[ :expected :index | self assertMethodSourceCode: (codes at: index) equals: expected ].
	res := (items at: 4) inputAmplifyBy: transplanter.
	codes := self sortResult: res.
	self assert: codes size equals: 3.
	{}
		doWithIndex:
			[ :expected :index | self assertMethodSourceCode: (codes at: index) equals: expected ].
	res := (items at: 5) inputAmplifyBy: transplanter.
	codes := self sortResult: res.
	self assert: codes size equals: 6.
	{'test
	| s0 c |
	1 + x.
	c := 15.
	s0 := c asString' . 'test
	| s0 c |
	c := 15.
	z := c asString.
	1 + x.
	s0 := z' . 'test
	| s0 |
	1 + x.
	s0 := String
		streamContents: [ :stream | 
			stream
				nextPutAll: ''Foo'';
				lf;
				nextPutAll: ''Bar'' ]' . 'test
	| s0 |
	1 + x.
	s0 := x asString' . 'test
	| s0 |
	z := String
		streamContents: [ :stream | 
			stream
				nextPutAll: ''Foo'';
				lf;
				nextPutAll: ''Bar'' ].
	1 + x.
	s0 := z' . 'test
	| s0 |
	z := x asString.
	1 + x.
	s0 := z'}
		doWithIndex:
			[ :expected :index | self assertMethodSourceCode: (codes at: index) equals: expected ].
	res := (items at: 6) inputAmplifyBy: transplanter.
	codes := self sortResult: res.
	self assert: codes size equals: 6.
	{'test
	| s1 c |
	c := 15.
	c := 15.
	s1 := c asString' . 'test
	| s1 c |
	c := 15.
	s1 := String
		streamContents: [ :stream | 
			stream
				nextPutAll: ''Foo'';
				lf;
				nextPutAll: ''Bar'' ]' . 'test
	| s1 c |
	c := 15.
	s1 := x asString'}
		doWithIndex:
			[ :expected :index | self assertMethodSourceCode: (codes at: index) equals: expected ]
]

{ #category : #tests }
SAInstantiationTransplanterTest >> testCase3 [
	| aSAObjectInstantiationExtractor items res codes |
	self genClass3.
	aSAObjectInstantiationExtractor := SAObjectInstantiationExtractor new.
	aSAObjectInstantiationExtractor testClass: cls.
	aSAObjectInstantiationExtractor run.
	transplanter
		instantiationPatterns: aSAObjectInstantiationExtractor patterns.
	items := #(testO0 )
		collect: [ :sel | 
			SATestMethod
				with: (cls >> sel) sourceCode
				class: cls
				targets: {ByteString} ].
	res := items first inputAmplifyBy: transplanter.
	codes := self sortResult: res.
	self assert: codes size equals: 2.
	self
		assertMethodSourceCode: codes first
		equals:
			'test
	| s0 t |
	t := FakeSmallBank new.
	s0 := String
		streamContents: [ :stream | 
			stream
				nextPutAll: t balance asString;
				lf;
				nextPutAll: ''Bar'' ]'.
	self
		assertMethodSourceCode: codes second
		equals:
			'test
	| s0 |
	s0 := String
		streamContents: [ :stream | 
			stream
				nextPutAll: s balance asString;
				lf;
				nextPutAll: ''Foo'' ]'.
	
]
