Class {
	#name : #SAAbstractSelection,
	#superclass : #Object,
	#category : #'SmallAmp-Core'
}

{ #category : #enumerating }
SAAbstractSelection class >> select: aPopulation alreadySelected: aPopulationAll [
	^ self new select: aPopulation alreadySelected: aPopulationAll
]

{ #category : #enumerating }
SAAbstractSelection >> select: aPopulation alreadySelected: aPopulationAll [
	self subclassResponsibility
]
