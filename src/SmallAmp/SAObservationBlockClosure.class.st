Class {
	#name : #SAObservationBlockClosure,
	#superclass : #SAObservationPrimitive,
	#category : #'SmallAmp-Model'
}

{ #category : #'as yet unclassified' }
SAObservationBlockClosure >> buildAssertions: aGenerator [
active
		ifFalse: [ ^ {} ].
	^ aGenerator buildAssertionsBlockClosureObservation: self
]

{ #category : #'as yet unclassified' }
SAObservationBlockClosure >> valueNode [
	^ RBLiteralValueNode
		value: theValue sourceNode formattedCode
]
