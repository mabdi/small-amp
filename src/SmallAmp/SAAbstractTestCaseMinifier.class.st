Class {
	#name : #SAAbstractTestCaseMinifier,
	#superclass : #Object,
	#instVars : [
		'config',
		'newTestClass',
		'testClass',
		'targetClasses',
		'minifiedTestClass',
		'minifiedAddedTestClass'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SAAbstractTestCaseMinifier class >> initializeWith: aConfig [
	^ self new
		  with: aConfig
]

{ #category : #'as yet unclassified' }
SAAbstractTestCaseMinifier >> makeMinifiedResult [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SAAbstractTestCaseMinifier >> minifiedAddedTestClass [
	^ minifiedAddedTestClass
]

{ #category : #accessing }
SAAbstractTestCaseMinifier >> minifiedTestClass [
	^ minifiedTestClass
]

{ #category : #'instance creation' }
SAAbstractTestCaseMinifier >> with: aConfig [
	self initialize.
	config := aConfig
]

{ #category : #'as yet unclassified' }
SAAbstractTestCaseMinifier >> with: newClass from: originalTestClass target: listTtargetClasses [
	newTestClass := newClass.
	 testClass := originalTestClass.
	 targetClasses := listTtargetClasses.
]
