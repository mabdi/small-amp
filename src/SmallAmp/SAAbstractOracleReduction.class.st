Class {
	#name : #SAAbstractOracleReduction,
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
SAAbstractOracleReduction class >> initializeWith: aConfig [
	^ self new
		  with: aConfig
]

{ #category : #'as yet unclassified' }
SAAbstractOracleReduction >> makeMinifiedResult [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SAAbstractOracleReduction >> minifiedAddedTestClass [
	^ minifiedAddedTestClass
]

{ #category : #accessing }
SAAbstractOracleReduction >> minifiedTestClass [
	^ minifiedTestClass
]

{ #category : #'instance creation' }
SAAbstractOracleReduction >> with: aConfig [
	self initialize.
	config := aConfig
]

{ #category : #'as yet unclassified' }
SAAbstractOracleReduction >> with: newClass from: originalTestClass target: listTtargetClasses [
	newTestClass := newClass.
	 testClass := originalTestClass.
	 targetClasses := listTtargetClasses.
]
