Class {
	#name : #SAObservationClass,
	#superclass : #SAObservationPrimitive,
	#category : #'SmallAmp-Model'
}

{ #category : #'as yet unclassified' }
SAObservationClass >> buildAssertions: aGenerator [
	^ aGenerator buildAssertionsClass: self
]

{ #category : #'as yet unclassified' }
SAObservationClass >> valueNode [
	^ RBVariableNode named: theValue name
]
