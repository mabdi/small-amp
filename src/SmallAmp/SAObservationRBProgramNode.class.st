Class {
	#name : #SAObservationRBProgramNode,
	#superclass : #SAObservationValue,
	#category : #'SmallAmp-Model'
}

{ #category : #'as yet unclassified' }
SAObservationRBProgramNode >> buildAssertions: aGenerator [
active
		ifFalse: [ ^ {} ].
	^ aGenerator buildAssertionsRBProgramNode: self
]

{ #category : #'as yet unclassified' }
SAObservationRBProgramNode >> valueNode [
	^ RBLiteralValueNode
		value: theValue formattedCode
]
