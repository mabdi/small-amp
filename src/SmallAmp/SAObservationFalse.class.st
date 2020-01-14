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
	^ aGenerator buildAssertionsFalseObservation: self
]
