"
A SATestCaseConfigurationTest is a test class for testing the behavior of SATestCaseConfiguration
"
Class {
	#name : #SATestCaseConfigurationTest,
	#superclass : #TestCase,
	#category : #'Amplification-Spec-Tests-Model'
}

{ #category : #test }
SATestCaseConfigurationTest >> testIcon [
	| config |
	config := SATestCaseConfiguration testCase: SATestCaseConfigurationTest.
	
	self assert: config icon equals: config targetNotSetIcon.

	config targetClass: SATestCaseConfiguration.
	
	self assert: config icon equals: config targetSetIcon.
]

{ #category : #test }
SATestCaseConfigurationTest >> testIsTargetSet [
	self deny: (SATestCaseConfiguration testCase: SATestCaseConfigurationTest) isTargetSet.
	
	self assert: (SATestCaseConfiguration testCase: SATestCaseConfigurationTest target: SATestCaseConfiguration) isTargetSet.
]

{ #category : #test }
SATestCaseConfigurationTest >> testSuggestTargetClassName [
	| config |
	config := SATestCaseConfiguration testCase: SATestCaseConfigurationTest.
	
	self assert: config suggestTargetClassName equals: 'SATestCaseConfiguration'
]
