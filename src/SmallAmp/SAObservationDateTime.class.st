Class {
	#name : #SAObservationDateTime,
	#superclass : #SAObservationPrimitive,
	#category : #'SmallAmp-Model'
}

{ #category : #'as yet unclassified' }
SAObservationDateTime >> buildAssertions: aGenerator [
	^ aGenerator buildAssertionsDateTimeObservation:  self
]
