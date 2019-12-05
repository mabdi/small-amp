Class {
	#name : #SATestCaseConfiguration,
	#superclass : #Object,
	#instVars : [
		'testCase',
		'targetClass'
	],
	#category : #'Amplification-Spec-Model'
}

{ #category : #'instance creation' }
SATestCaseConfiguration class >> testCase: aTestClass [
	^ self new
		testCase: aTestClass;
		yourself
]

{ #category : #'instance creation' }
SATestCaseConfiguration class >> testCase: aTestClass target: aClass [
	^ self new
		testCase: aTestClass;
		targetClass: aClass;
		yourself
]

{ #category : #accessing }
SATestCaseConfiguration >> displayStringOn: aStream [
	aStream nextPutAll: self testCase name
]

{ #category : #accessing }
SATestCaseConfiguration >> icon [
	^ self isTargetSet
		ifTrue: [ self targetSetIcon ]
		ifFalse: [ self targetNotSetIcon ]
]

{ #category : #testing }
SATestCaseConfiguration >> isTargetSet [
	^ self targetClass isNotNil
]

{ #category : #accessing }
SATestCaseConfiguration >> suggestTargetClassName [
	self flag: #TODO. "The code should handle special cases where the test case name does not end with 'Test'."
	^ self testCase name allButLast: 'Test' size
]

{ #category : #accessing }
SATestCaseConfiguration >> targetClass [
	^ targetClass
]

{ #category : #accessing }
SATestCaseConfiguration >> targetClass: anObject [
	targetClass := anObject
]

{ #category : #accessing }
SATestCaseConfiguration >> targetNotSetIcon [
	^ #error
]

{ #category : #accessing }
SATestCaseConfiguration >> targetSetIcon [
	^ #glamorousAccept
]

{ #category : #accessing }
SATestCaseConfiguration >> testCase [
	^ testCase
]

{ #category : #accessing }
SATestCaseConfiguration >> testCase: anObject [
	testCase := anObject
]
