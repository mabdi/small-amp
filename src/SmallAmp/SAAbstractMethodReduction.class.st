Class {
	#name : #SAAbstractMethodReduction,
	#superclass : #Object,
	#instVars : [
		'config',
		'uncovered',
		'testRunTimeoutMillis'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #initialization }
SAAbstractMethodReduction class >> initializeWith: aConfig [
	^ self new with: aConfig
]

{ #category : #'as yet unclassified' }
SAAbstractMethodReduction >> reduceMethods: aListOfMethods [
	^ self subclassResponsibility
]

{ #category : #accessing }
SAAbstractMethodReduction >> testRunTimeoutMillis: anObject [
	testRunTimeoutMillis := anObject
]

{ #category : #accessing }
SAAbstractMethodReduction >> uncovered [
	^ uncovered
]

{ #category : #accessing }
SAAbstractMethodReduction >> uncovered: anObject [
	uncovered := anObject
]

{ #category : #'instance creation' }
SAAbstractMethodReduction >> with: aConfig [
	self initialize.
	config := aConfig
]
