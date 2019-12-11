Class {
	#name : #SAAbstractSelector,
	#superclass : #Object,
	#category : #'Amplification-Core'
}

{ #category : #enumerating }
SAAbstractSelector >> doSelect: aPopulation selected: aPopulationAll [
	self subclassResponsibility
]
