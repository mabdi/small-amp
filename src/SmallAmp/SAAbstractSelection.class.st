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
SAAbstractSelection class >> select: aPopulation alreadySelected: aPopulationAll [
	^ self new select: aPopulation alreadySelected: aPopulationAll
]

{ #category : #enumerating }
SAAbstractSelection >> select: aPopulation alreadySelected: aPopulationAll [
	self subclassResponsibility
]

{ #category : #'instance creation' }
SAAbstractSelection >> with: aConfig [
	self initialize.
	config := aConfig
]