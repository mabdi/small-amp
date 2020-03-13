Class {
	#name : #SAAbstractSelection,
	#superclass : #Object,
	#instVars : [
		'config'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #initialization }
SAAbstractSelection class >> initializeWith: aConfig [
	^ self new with: aConfig
]

{ #category : #enumerating }
SAAbstractSelection >> select: aPopulation uncovered: uncoveredList [
	self subclassResponsibility
]

{ #category : #accessing }
SAAbstractSelection >> uncovered [
	^ self subclassResponsibility 
]

{ #category : #'instance creation' }
SAAbstractSelection >> with: aConfig [
	self initialize.
	config := aConfig
]
