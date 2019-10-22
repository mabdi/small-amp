Class {
	#name : #CharacterSerializer,
	#superclass : #PrimitiveSerializer,
	#category : #'Amplification-Helpers'
}

{ #category : #accessing }
CharacterSerializer class >> priority [
	^ 10
]

{ #category : #'as yet unclassified' }
CharacterSerializer class >> supportingTypes [
	^ {Character}
]

{ #category : #'as yet unclassified' }
CharacterSerializer class >> unserialize: dictionary [
	^ (dictionary at: #value) at: 1
]
