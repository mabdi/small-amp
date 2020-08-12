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
active
		ifFalse: [ ^ {} ].
	^ aGenerator buildAssertionsTrueObservation: self
]

{ #category : #'as yet unclassified' }
SAObservationTrue >> valueNode [
	^ RBLiteralValueNode value: true
]
