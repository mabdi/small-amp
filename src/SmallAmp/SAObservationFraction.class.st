Class {
	#name : #SAObservationFraction,
	#superclass : #SAObservationPrimitive,
	#category : #'SmallAmp-Model'
}

{ #category : #'as yet unclassified' }
SAObservationFraction >> buildAssertions: aGenerator [
active
		ifFalse: [ ^ {} ].
	^ aGenerator buildAssertionsFractionObservation: self
]

{ #category : #'as yet unclassified' }
SAObservationFraction >> valueNode [
	^ RBMessageNode
		receiver: (RBLiteralValueNode value: theValue numerator )
		selector: #/
		arguments: {(RBLiteralValueNode value: theValue denominator )}
]
