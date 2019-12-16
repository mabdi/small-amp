Class {
	#name : #SAObservationFraction,
	#superclass : #SAObservationPrimitive,
	#category : #'SmallAmp-Model'
}

{ #category : #'as yet unclassified' }
SAObservationFraction >> buildAssertions: aGenerator [
	^ aGenerator buildAssertionsFractionObservation: self
]
