Class {
	#name : #SAAbstractTestCaseMinifier,
	#superclass : #Object,
	#instVars : [
		'newTestClass',
		'testClass',
		'targetClasses',
		'minifiedTestClass',
		'minifiedAddedTestClass'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SAAbstractTestCaseMinifier class >> with: newClass from: originalTestClass target: listTtargetClasses [
	^ self new with: newClass from: originalTestClass target: listTtargetClasses; yourself 
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

{ #category : #'as yet unclassified' }
SAAbstractTestCaseMinifier >> with: newClass from: originalTestClass target: listTtargetClasses [
	newTestClass := newClass.
	 testClass := originalTestClass.
	 targetClasses := listTtargetClasses.
]
