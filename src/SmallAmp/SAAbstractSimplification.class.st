Class {
	#name : #SAAbstractSimplification,
	#superclass : #Object,
	#instVars : [
		'config'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #initialization }
SAAbstractSimplification class >> initializeWith: aConfig [
	^ self new with: aConfig
]

{ #category : #enumerating }
SAAbstractSimplification class >> select: aPopulation alreadySelected: aPopulationAll [
	^ self new select: aPopulation alreadySelected: aPopulationAll
]

{ #category : #'as yet unclassified' }
SAAbstractSimplification >> simplify: aClass [ 
	self subclassResponsibility 
]

{ #category : #'instance creation' }
SAAbstractSimplification >> with: aConfig [
	self initialize.
	config := aConfig
]
