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
SAASTHelperTest >> testAddCommentToMethodQuote [
	| h src2 |
	h := SAASTHelper new.
	src2 := h addComment: 'some " comments is here' toMethod: 'foo x:=1'.
	self assertMethodSourceCode: src2 equals: (RBParser parseMethod: 'foo ''some " comments is here''. x:=1') formattedCode 
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
SAASTHelperTest >> testGrindTestClassSize [
	| helper cls grinded |
	helper := SAASTHelper new.
	cls := TestCase
		subclass: 'SAFakeTestForGrind' , helper getId asString
		instanceVariableNames: 'i j k'
		classVariableNames: 'a b c'
		package: helper defaultTempPackage.
	1 to: 32 do: [ :i | cls compile: 'testNum' , i asString , ' self assert: true' ].
	cls compile: 'helperMethod ^ 1'.
	grinded := helper grindTestClass: cls size: 20.
	self assert: grinded size equals: 2.
	self assert: grinded first testSelectors size equals: 20.
	self
		assert: (grinded first class >> #allTestSelectors) sourceCode
		equals: helper srcAllTestSelectors.
	self
		assert: grinded first smallAmpTargetClasses
		equals: cls smallAmpTargetClasses.
	self
		assert: grinded first smallAmpOriginalTestCase
		equals: cls.
	self
		assert: grinded second smallAmpOriginalTestCase
		equals: cls.
	self
		assert: grinded second smallAmpTargetClasses
		equals: cls smallAmpTargetClasses.
	self assert: grinded second testSelectors size equals: 12.
	grinded do: #removeFromSystem.
	cls removeFromSystem
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

{ #category : #test }
SAASTHelperTest >> testRunSafelyTimeOut [
	 
			[(SAASTHelper new
				runSafely: [ 200 milliSeconds wait.
					self deny: true ]
				timeOut: 100 milliSeconds)] on: SAUnsafeRunKilled  do: [ self assert: true ]
		
]

{ #category : #test }
SAASTHelperTest >> testRunSafelyTimeOutSemaphor [
	| semaphor |
	semaphor := Semaphore new.
	[ 1 seconds wait.
	semaphor signal.
	self assert: false ] forkAt: Processor activePriority + 1.
	[ SAASTHelper new
		runSafely: [ semaphor wait.
			self assert: false ]
		timeOut: 100 milliSeconds ]
		on: SAUnsafeRunKilled
		do: [ self assert: true ]
]

{ #category : #test }
SAASTHelperTest >> testStrip [
	| sourceCode expectingCode result |
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
	'.
	result := SAASTHelper new strip: sourceCode.
	self assertMethodSourceCode: result equals: expectingCode.
	sourceCode := 'foo
	self assert: foo bar equals: 1.
	self deny: self hello.
	self assert: tmp1 isNotEmpty'.
	expectingCode := 'foo
	foo bar = 1.
	self hello value not.
	tmp1 isNotEmpty value	
	'.
	result := SAASTHelper new strip: sourceCode.
	self assertMethodSourceCode: result equals: expectingCode.
	
]
