Class {
	#name : #SAAbstractSelection,
	#superclass : #Object,
	#category : #'Amplification-Core'
}

{ #category : #enumerating }
SAAbstractSelection >> doSelect: aPopulation selected: aPopulationAll [
	self subclassResponsibility
]
