Class {
	#name : #AbstractSelector,
	#superclass : #Object,
	#category : #'Amplification-Core'
}

{ #category : #enumerating }
AbstractSelector >> doSelect: aPopulation selected: aPopulationAll [
	self subclassResponsibility
]
