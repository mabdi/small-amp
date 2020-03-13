Class {
	#name : #SAAbstractSimplification,
	#superclass : #Object,
	#instVars : [
		'config',
		'theClass'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #initialization }
SAAbstractSimplification class >> initializeWith: aConfig [
	^ self new with: aConfig
]

{ #category : #'as yet unclassified' }
SAAbstractSimplification >> simplify [ 
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SAAbstractSimplification >> simplify: aClass [
	theClass := aClass.
	self simplify 
]

{ #category : #'instance creation' }
SAAbstractSimplification >> with: aConfig [
	self initialize.
	config := aConfig
]
