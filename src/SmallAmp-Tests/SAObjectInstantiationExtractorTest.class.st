"
A SAObjectInstantiationExtractorTest is a test class for testing the behavior of SAObjectInstantiationExtractor
"
Class {
	#name : #SAObjectInstantiationExtractorTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Helpers'
}

{ #category : #tests }
SAObjectInstantiationExtractorTest >> testNumber1 [
	| instance |
	instance := SAObjectInstantiationExtractor new.
	instance testClass: FakeSmallBankTest.
	instance run.
	self assert: instance patterns size equals: 1.
	self
		assert: (((instance patterns at: #FakeSmallBank) asArray first) at: #node)
		equals: (RBParser parseExpression: 'FakeSmallBank  with: #empty')
]

{ #category : #tests }
SAObjectInstantiationExtractorTest >> testNumber2 [
	| instance |
	instance := SAObjectInstantiationExtractor new.
	instance testClass: SAFakeForInstantioationExtractTests.
	instance run.
	self assert: (instance patterns keys includes: #SmallAmp).
	self assert: (instance patterns keys includes: #SAConfig).
	self assert: (instance patterns keys includes: #Fraction).
	self assert: (instance patterns keys includesAnyOf: #(BlockClosure FullBlockClosure)).	
]
