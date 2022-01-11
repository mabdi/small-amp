"
A SADefaultTestCorrectionTest is a test class for testing the behavior of SADefaultTestCorrection
"
Class {
	#name : #SADefaultTestCorrectionTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Core'
}

{ #category : #tests }
SADefaultTestCorrectionTest >> testAssertEqualsErrorBlocks [

	| method ins src2 ast |
	ins := SADefaultTestCorrection new.
	method := 'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t1 := ins method1.
	self assert: t1 someMethod equals: 10.
	t3 := ins2 method2.
	self assert: t3 someMethod equals: ''sss''.
	t3 := t1 method2.
	'.
	ast := SAGenericMethods new parsedMethodFrom: method.
	src2 := ins addErrorBlocksAroundAllAssertEqualsIn: ast.
	self
		assertMethodSourceCode: src2 formattedCode
		equals: 'testSomeThing

	<madeBySmallAmp>
	| t1 t2 t3 |
	t1 := ins method1.
	self smallamp_logs: ''testSomeThing::0'' -> (t1 someMethod).
	t3 := ins2 method2.
	self smallamp_logs: ''testSomeThing::1'' -> (t3 someMethod).
	t3 := t1 method2
	'
]

{ #category : #test }
SADefaultTestCorrectionTest >> testUpdateLiteralsInAssertionsIn [

	| fakeTest theCorr newAST |
	fakeTest := FakeForTestCorrectionTest >> #testCorrectMe.
	theCorr := SADefaultTestCorrection new
		           config: SAConfig default;
		           theClass: fakeTest methodClass.
	newAST := theCorr updateLiteralsInAssertionsIn: fakeTest ast.
	self
		assertMethodSourceCode:
		newAST formattedCode
		equals: 'testCorrectMe

	| str |
	str := ''Hello world''.
	self assert: str size equals: 11.
	self assert: str first equals: $H.
	self assert: str second equals: $e'.
	fakeTest methodClass compile: fakeTest sourceCode
]

{ #category : #test }
SADefaultTestCorrectionTest >> testUpdateVariablesInBasedOn [

	| fakeTest theCorr logs newAST |
	logs := { 
		        ('testCorrectMe::0' -> 10).
					('testCorrectMe::1' -> $H).
		        ('testCorrectMe::2' -> $e) }.
	fakeTest := FakeForTestCorrectionTest >> #testCorrectMe.
	theCorr := SADefaultTestCorrection new
		           config: SAConfig default;
		           theClass: fakeTest methodClass.
	newAST := theCorr updateVariablesIn: fakeTest ast basedOn: logs.
	self
		assertMethodSourceCode: newAST formattedCode
		equals: 'testCorrectMe

	| str |
	str := ''Hello world''.
	self assert: str size equals: 10.
	self assert: str first equals: $H.
	self assert: str second equals: $e'
]
