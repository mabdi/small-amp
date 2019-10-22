Class {
	#name : #ByteStringSerializer,
	#superclass : #PrimitiveSerializer,
	#category : #'Amplification-Helpers'
}

{ #category : #accessing }
ByteStringSerializer class >> priority [
	^ 10
]

{ #category : #'as yet unclassified' }
ByteStringSerializer class >> supportingTypes [
	^ {ByteString}
]

{ #category : #'as yet unclassified' }
ByteStringSerializer class >> unserialize: dictionary [
	^ dictionary at: #value
]
