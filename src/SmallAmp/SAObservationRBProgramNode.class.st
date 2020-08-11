Class {
	#name : #SAObservationRBProgramNode,
	#superclass : #SAObservationObject,
	#category : #'SmallAmp-Model'
}

{ #category : #'as yet unclassified' }
SAObservationRBProgramNode >> buildAssertions: aGenerator [
	^ aGenerator buildAssertionsRBProgramNode: self
]
