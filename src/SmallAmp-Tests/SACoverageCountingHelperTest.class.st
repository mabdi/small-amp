Class {
	#name : #SACoverageCountingHelperTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Helpers'
}

{ #category : #tests }
SACoverageCountingHelperTest >> getClassUnderTest [

	^ FakeSmallBank
]

{ #category : #tests }
SACoverageCountingHelperTest >> getMethodsUnderTest [

	^ { 
				  (self getClassUnderTest >> #deposit:).
				  (self getClassUnderTest >> #withdraw:).
				  (self getClassUnderTest >> #balance) }
]

{ #category : #tests }
SACoverageCountingHelperTest >> getTestClass [

	^ FakeSmallBankTest
]

{ #category : #running }
SACoverageCountingHelperTest >> setUp [

	super setUp.

	
]

{ #category : #tests }
SACoverageCountingHelperTest >> testAllCoveredMethods [

	| testMethod allCovered |
	testMethod := 'testTempLoadFrom

	| b1 b2 |
	b1 := FakeSmallBank new.
	b1 deposit: 40.
	b2 := FakeSmallBank new.
	b2 loadFrom: b1.'.
	allCovered := SACoverageCountingHelper new
		                    selector: #testTempLoadFrom;
		                    testMethod: testMethod;
		                    testClass: self getTestClass;
		                    coverageOn: { self getClassUnderTest }.
	allCovered := allCovered findAllCoveredMethods.
	self assert: allCovered isNotEmpty.
	self assert: (allCovered includesAll: ({ 
				(self getClassUnderTest >> #deposit:).  
				(self getClassUnderTest >> #balance).
				  (self getClassUnderTest >> #initialize) } collect: #name)).
	
]

{ #category : #tests }
SACoverageCountingHelperTest >> testImmediateCovered [

	| immediateCovered |
	immediateCovered := SACoverageCountingHelper new
		                    selector: #testWithdraw;
		                    testMethod:
			                    (FakeSmallBankTest >> #testWithdraw) sourceCode;
		                    testClass: self getTestClass;
		                    coverageOn: { self getClassUnderTest }.
	immediateCovered := immediateCovered findImmediateCoveredMethods.
	self assert: immediateCovered isNotEmpty.
	self assert: (immediateCovered includesAll:
			 (self getMethodsUnderTest collect: #name)).
	self deny: (immediateCovered includes: 
				  (self getClassUnderTest >> #initialize) name)
]
