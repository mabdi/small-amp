Class {
	#name : #SAAbstractMethodReduction,
	#superclass : #Object,
	#instVars : [
		'config',
		'uncovered'
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
