"
A SAAmplificationConfigurationTest is a test class for testing the behavior of SAAmplificationConfiguration
"
Class {
	#name : #SAAmplificationConfigurationTest,
	#superclass : #TestCase,
	#instVars : [
		'config'
	],
	#category : #'SmallAmp-Spec-Tests-Model'
}

{ #category : #test }
SAAmplificationConfigurationTest >> testAddConfiguration [
	| toAdd |
	config := SAAmplificationConfiguration new.
	
	toAdd := SATestCaseConfiguration testCase: SAAmplificationConfigurationTest target: SAAmplificationConfiguration.
	config addConfiguration: toAdd.
	
	self assert: config testCaseConfigurations size equals: 1.
	self assert: config testCaseConfigurations anyOne equals: toAdd.
]

{ #category : #test }
SAAmplificationConfigurationTest >> testInitialize [
	config := SAAmplificationConfiguration new.
	
	self assert: config testCaseConfigurations isEmpty
]
