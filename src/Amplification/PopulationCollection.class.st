Class {
	#name : #PopulationCollection,
	#superclass : #OrderedCollection,
	#category : #'Amplification-Core'
}

{ #category : #initialization }
PopulationCollection class >> setUpWith: aCollection [
	^ self withAll: aCollection 
]

{ #category : #copying }
PopulationCollection >> clone [ 
	|result|
	result := self class new.
	self do: [ :item | result add: item clone ].
	^ result 
]

{ #category : #'as yet unclassified' }
PopulationCollection >> collect: aBlock displayingProgress: aStringOrBlock [
	| newCollection |
	newCollection := self species new.
	self do: [ :each | newCollection add: (aBlock value: each) ] displayingProgress: aStringOrBlock.
	^ newCollection
]
