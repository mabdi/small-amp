Class {
	#name : #SAObservationBlockClosure,
	#superclass : #SAObservationPrimitive,
	#category : #'SmallAmp-Model'
}

{ #category : #'as yet unclassified' }
SAObservationBlockClosure >> buildAssertions: aGenerator [
	^ aGenerator buildAssertionsBlockClosureObservation: self
]
