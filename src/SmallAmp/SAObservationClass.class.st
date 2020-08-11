Class {
	#name : #SAObservationClass,
	#superclass : #SAObservationPrimitive,
	#category : #'SmallAmp-Model'
}

{ #category : #'as yet unclassified' }
SAObservationClass >> buildAssertions: aGenerator [
	^ aGenerator buildAssertionsClass: self
]
