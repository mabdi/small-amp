Class {
	#name : #SAAmplificationConfiguration,
	#superclass : #Object,
	#instVars : [
		'testCaseConfigurations'
	],
	#category : #'SmallAmp-Spec-Model'
}

{ #category : #adding }
SAAmplificationConfiguration >> addConfiguration: aTestCaseConfiguration [
	self testCaseConfigurations add: aTestCaseConfiguration
]

{ #category : #initialization }
SAAmplificationConfiguration >> initialize [
	super initialize.
	self testCaseConfigurations: OrderedCollection new
]

{ #category : #accessing }
SAAmplificationConfiguration >> testCaseConfigurations [
	^ testCaseConfigurations
]

{ #category : #accessing }
SAAmplificationConfiguration >> testCaseConfigurations: anObject [
	testCaseConfigurations := anObject
]
