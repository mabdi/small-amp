Class {
	#name : #SAObservationTrue,
	#superclass : #SAObservationPrimitive,
	#category : #'SmallAmp-Model'
}

{ #category : #'instance creation' }
SAObservationTrue class >> newAtDepth: anInteger [
	^ self newForClass: True values: true atDepth: anInteger
]

{ #category : #'as yet unclassified' }
SAObservationTrue >> buildAssertions: aGenerator [
	^ aGenerator buildAssertionsTrueObservation: self
]
