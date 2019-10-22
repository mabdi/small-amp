Class {
	#name : #FractionSerializer,
	#superclass : #NumberSerializer,
	#category : #'Amplification-Helpers'
}

{ #category : #'as yet unclassified' }
FractionSerializer class >> priority [
	
	^ 9
]

{ #category : #'as yet unclassified' }
FractionSerializer class >> supportingTypes [
	^ {Fraction}
]

{ #category : #'as yet unclassified' }
FractionSerializer class >> unserialize: dictionary [
	| val |
	val := (dictionary at: #value) copyWithoutAll: '()'.
	^ Fraction readFrom: val
]
