Class {
	#name : #SAAbstractOracleReduction,
	#superclass : #Object,
	#instVars : [
		'config',
		'newTestClass',
		'testClass',
		'targetClasses',
		'reducedTestClass',
		'reducedAddedTestClass'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SAAbstractOracleReduction class >> initializeWith: aConfig [
	^ self new
		  with: aConfig
]

{ #category : #'as yet unclassified' }
SAAbstractOracleReduction >> makeReducedResult [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SAAbstractOracleReduction >> reducedAddedTestClass [
	^ reducedAddedTestClass
]

{ #category : #accessing }
SAAbstractOracleReduction >> reducedTestClass [
	^ reducedTestClass
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
