"
A SAVariableTypeProfilerTest is a test class for testing the behavior of SAVariableTypeProfiler
"
Class {
	#name : #SAVariableTypeProfilerTest,
	#superclass : #TestCase,
	#instVars : [
		'profiler'
	],
	#category : #'SmallAmp-Tests-Helpers'
}

{ #category : #running }
SAVariableTypeProfilerTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	| config |
	config := SAConfig default.
	profiler := SAVariableTypeProfiler initializeWith: config.
	
]

{ #category : #tests }
SAVariableTypeProfilerTest >> testCase1 [
	| testClass variableTypes |
	testClass := FakeSmallBankTest.
	variableTypes := profiler
		testMethods:
			(testClass allTestSelectors
				collect: [ :s | (testClass lookupSelector: s) sourceCode ]);
		testClass: testClass;
		run;
		variablesTypes.
	self
		assert:
			(variableTypes at: SAVariableTypeProfiler instanceVariablesKey)
				isEmpty.
	self
		assert: (variableTypes at: #'testDeposit:b')
		equals: FakeSmallBank
]

{ #category : #tests }
SAVariableTypeProfilerTest >> testCase2 [
	| testClass variableTypes |
	testClass := SAASTHelper new
		makeClassFrom: {'testO1 |x y| x := 10. y := x / 3'}
		instanceVars: ''.
	variableTypes := profiler
		testMethods:
			(testClass allTestSelectors
				collect: [ :s | (testClass lookupSelector: s) sourceCode ]);
		testClass: testClass;
		run;
		variablesTypes.
	self
		assert:
			(variableTypes at: SAVariableTypeProfiler instanceVariablesKey)
				isEmpty.
	self assert: (variableTypes at: #'testO1:x') equals: SmallInteger.
	self assert: (variableTypes at: #'testO1:y') equals: Fraction.
	testClass removeFromSystem
]

{ #category : #tests }
SAVariableTypeProfilerTest >> testCase3 [
	| testClass variableTypes |
	testClass := SAASTHelper new
		makeClassFrom:
			{'setUp f := FakeSmallBank new' . 'testO1 |x| x := 10. self assert: f balance equals: 0'}
		instanceVars: 'f'.
	variableTypes := profiler
		testMethods:
			(testClass allTestSelectors
				collect: [ :s | (testClass lookupSelector: s) sourceCode ]);
		testClass: testClass;
		run;
		variablesTypes.
	self
		assert: (variableTypes at: SAVariableTypeProfiler instanceVariablesKey)
		equals: {(#f -> FakeSmallBank)} asOrderedCollection.
	self assert: (variableTypes at: #'testO1:x') equals: SmallInteger.
	testClass removeFromSystem
]

{ #category : #tests }
SAVariableTypeProfilerTest >> testCase4 [
	| testClass variableTypes |
	testClass := SAASTHelper new
		makeClassFrom: {'setUp f := FakeSmallBank new' . 'testO1 '}
		instanceVars: 'f'.
	variableTypes := profiler
		testMethods:
			(testClass allTestSelectors
				collect: [ :s | (testClass lookupSelector: s) sourceCode ]);
		testClass: testClass;
		run;
		variablesTypes.
	self
		assert: (variableTypes at: SAVariableTypeProfiler instanceVariablesKey)
		equals: {(#f -> FakeSmallBank)} asOrderedCollection.
	
	testClass removeFromSystem
]
