"
A SAASTHelperTest is a test class for testing the behavior of SAASTHelper
"
Class {
	#name : #SAGenericMethodsTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Helpers'
}

{ #category : #test }
SAGenericMethodsTest >> testAddCommentToMethod [
	| h src2 |
	h := SAGenericMethods new.
	src2 := h
		addComment: 'some comments is here'
		toMethodAST: (h parsedMethodFrom: 'foo x:=1').
	self
		assertMethodSourceCode: src2 formattedCode
		equals:
			'foo "some comments is here" x:=1'
]

{ #category : #test }
SAGenericMethodsTest >> testAddCommentToMethodQuote [
	| h src2 |
	h := SAGenericMethods new.
	src2 := h
		addComment: 'some " comments is here'
		toMethodAST: (h parsedMethodFrom: 'foo x:=1').
	self
		assertMethodSourceCode: src2 formattedCode
		equals:
			'foo ''some " comments is here''. x:=1'
]

{ #category : #test }
SAGenericMethodsTest >> testBuildTestClassAndRun [
	| result methods testMethods |
	testMethods := SAAssertTransformTest methods
		select: [ :each | each selector beginsWith: 'test' ].
	methods := testMethods
		collect: [ :atestMethod | atestMethod sourceCode ].
	result := SAGenericMethods new
		buildTestClassWith: methods allButFirst
		using: SAAssertTransformTest.
	self assert: result superclass equals: SAAssertTransformTest.
	self deny: (result selectors includes: testMethods first selector).
	SAGenericMethods new removeClass: result source: self class name
]

{ #category : #test }
SAGenericMethodsTest >> testCleanUp [
	| s r |
	s := 'testWithdraw_1_1
	| b tmp_ZISDO00DGz1 tmp_9nbUP3optD2 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp_ZISDO00DGz1 := b deposit: 102.
	self assert: tmp_ZISDO00DGz1 balance equals: 102.
	tmp_9nbUP3optD2 := b withdraw: 30.
	self assert: b balance equals: 72'.
	r := SAGenericMethods new cleanUp: s.
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
SAGenericMethodsTest >> testGrindTestClassSize [
	| helper cls grinded |
	helper := SAGenericMethods new.
	cls := TestCase
		subclass: 'SAFakeTestForGrind' , helper getId asString
		instanceVariableNames: 'i j k'
		classVariableNames: 'a b c'
		package: helper defaultTempPackage.
	1 to: 32 do: [ :i | cls compile: 'testNum' , i asString , ' self assert: true' ].
	cls compile: 'helperMethod ^ 1'.
	grinded := helper performShredingOnTestClass: cls size: 20.
	self assert: cls smallAmpOriginalTestCase equals: cls.
	self assert: grinded size equals: 2.
	self assert: grinded first testSelectors size equals: 20.
	self assert: grinded first smallAmpOriginalTestCase equals: cls.
	self
		assert: (grinded first class >> #allTestSelectors) sourceCode
		equals: helper srcAllTestSelectors.
	self
		assert: grinded first smallAmpTargetClasses
		equals: cls smallAmpTargetClasses.
	self assert: grinded first smallAmpOriginalTestCase equals: cls.
	self assert: grinded second smallAmpOriginalTestCase equals: cls.
	self
		assert: grinded second smallAmpTargetClasses
		equals: cls smallAmpTargetClasses.
	self assert: grinded second testSelectors size equals: 12.
	grinded do: #removeFromSystem.
	cls removeFromSystem
]

{ #category : #test }
SAGenericMethodsTest >> testOldBuildTestClassAndRun [
	| result methods testMethods |
	testMethods := SAAssertTransformTest methods
		select: [ :each | each selector beginsWith: 'test' ].
	methods := testMethods
		collect: [ :atestMethod | atestMethod sourceCode ].
	result := SAGenericMethods new
		old_buildTestClassWith: methods
		using: SAAssertTransformTest.
	self
		deny: (result methods detect: [ :mtd | mtd selector = #setUp ]) isNil.
	self
		deny: (result methods detect: [ :mtd | mtd selector = #astHelper ]) isNil.
	self assert: result testSelectors size equals: methods size.
	SAGenericMethods new removeClass: result source: self class name
]

{ #category : #test }
SAGenericMethodsTest >> testPragma [
	| signed newSrc |
	signed := Fake2Test smallAmpAmplifiedMethods.
	self assert: signed size equals: 1.
	self assert: signed first selector equals: #testSigned.
	self assert: signed first isMadeBySmallAmp.
	self assert: signed first selector equals: #testSigned.
	newSrc := SAGenericMethods new signAsSmallAmp: 'testHi self assert: true'.
	self
		assert: (SAGenericMethods new parsedMethodFrom: newSrc) pragmas first selector
		equals: SAGenericMethods defaultPragma.
	
]

{ #category : #test }
SAGenericMethodsTest >> testRunSafelyTimeOut [
	 
			[(SAGenericMethods new
				runSafely: [ 200 milliSeconds wait.
					self deny: true ]
				timeOut: 100 milliSeconds)] on: SAUnsafeRunKilled  do: [ self assert: true ]
		
]

{ #category : #test }
SAGenericMethodsTest >> testRunSafelyTimeOutSemaphor [
	| semaphor |
	semaphor := Semaphore new.
	[ 1 seconds wait.
	semaphor signal.
	self assert: false ] forkAt: Processor activePriority + 1.
	[ SAGenericMethods new
		runSafely: [ semaphor wait.
			self assert: false ]
		timeOut: 100 milliSeconds ]
		on: SAUnsafeRunKilled
		do: [ self assert: true ]
]

{ #category : #tests }
SAGenericMethodsTest >> testShreding [

	| tests testClassUnderTest |
	testClassUnderTest := FakeLong1Test.
	tests := SAGenericMethods new shredTestClass: { testClassUnderTest } max: 5.
	self assert: tests size equals: (testClassUnderTest testSelectors size / 5) ceiling.
	self
		assert: tests first methods size
		equals: testClassUnderTest methods size - testClassUnderTest testSelectors size + 5.
	self
		assert: tests first allTestSelectors asSet
		equals:
		(testClassUnderTest superclass allTestSelectors asSet union:
			 tests first testSelectors).
	self assert: tests second allTestSelectors size equals: 5.
	self
		assert: tests last allTestSelectors size
		equals: testClassUnderTest testSelectors size - ((tests size - 1) * 5).
	self assert: tests first smallAmpOriginalTestCase equals: testClassUnderTest.
	self
		assert: tests first smallAmpOriginalTestCase
		equals: tests second smallAmpOriginalTestCase.
	self
		assert: tests first smallAmpTargetClasses
		equals: testClassUnderTest smallAmpTargetClasses.
	self
		assert: tests first smallAmpTargetClasses
		equals: tests second smallAmpTargetClasses.
	tests do: [ :test | test removeFromSystem ]
]

{ #category : #test }
SAGenericMethodsTest >> testStrip [
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
	result := SAGenericMethods new strip: sourceCode.
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
	result := SAGenericMethods new strip: sourceCode.
	self assertMethodSourceCode: result equals: expectingCode.
	
]
