Class {
	#name : #SAObservationFalse,
	#superclass : #SAObservationPrimitive,
	#category : #'SmallAmp-Model'
}

{ #category : #'instance creation' }
SAObservationFalse class >> newAtDepth: anInteger [
	^ self newForClass: False values: false atDepth: anInteger 
]

{ #category : #'as yet unclassified' }
SAObservationFalse >> buildAssertions: aGenerator [
active
		ifFalse: [ ^ {} ].
	^ aGenerator buildAssertionsFalseObservation: self
]

{ #category : #'as yet unclassified' }
SAObservationFalse >> valueNode [
	^ RBLiteralValueNode value: false
]
