Class {
	#name : #NumberSerializer,
	#superclass : #PrimitiveSerializer,
	#category : #'Amplification-Experiment'
}

{ #category : #accessing }
NumberSerializer class >> priority [
	^ 10
]

{ #category : #'as yet unclassified' }
NumberSerializer class >> supportingTypes [
	^ {Number}
]

{ #category : #'as yet unclassified' }
NumberSerializer class >> unserialize: dictionary [
	^ (dictionary at: #value) asNumber
]
