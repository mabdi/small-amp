Class {
	#name : #BooleanSerializer,
	#superclass : #PrimitiveSerializer,
	#category : #'Amplification-Experiment'
}

{ #category : #'as yet unclassified' }
BooleanSerializer class >> priority [ 
	^ 10
]

{ #category : #'as yet unclassified' }
BooleanSerializer class >> supportingTypes [
	^ { Boolean }
]

{ #category : #'as yet unclassified' }
BooleanSerializer class >> unserialize: dictionary [
	^ (dictionary at: #value) = true asString
]
