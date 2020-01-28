Class {
	#name : #SAObservationCompiledCode,
	#superclass : #SAObservationPrimitive,
	#category : #'SmallAmp-Model'
}

{ #category : #'as yet unclassified' }
SAObservationCompiledCode >> buildAssertions: aGenerator [
	^ aGenerator buildAssertionsCompiledCode: self
]
