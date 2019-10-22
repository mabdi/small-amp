Class {
	#name : #NilSerializer,
	#superclass : #PrimitiveSerializer,
	#category : #'Amplification-Helpers'
}

{ #category : #accessing }
NilSerializer class >> priority [
	^ 10
]

{ #category : #'as yet unclassified' }
NilSerializer class >> supportingTypes [
	^ {UndefinedObject}
]

{ #category : #'as yet unclassified' }
NilSerializer class >> unserialize: dictionary [
	^ nil
]
