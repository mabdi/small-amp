Class {
	#name : #SAObservationNil,
	#superclass : #SAObservationPrimitive,
	#category : #'SmallAmp-Model'
}

{ #category : #'instance creation' }
SAObservationNil class >> newAtDepth: anInteger [
	^ self newForClass: UndefinedObject values: nil atDepth: anInteger
]

{ #category : #'as yet unclassified' }
SAObservationNil >> buildAssertions: aGenerator [
	^ aGenerator buildAssertionsNilObservation: self
]
