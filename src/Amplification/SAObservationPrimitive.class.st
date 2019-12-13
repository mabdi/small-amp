Class {
	#name : #SAObservationPrimitive,
	#superclass : #SAObservationItem,
	#category : #'Amplification-Model'
}

{ #category : #adding }
SAObservationPrimitive >> checkFlaky: anItem [
	anItem theClass = self theClass ifFalse: [ self isFlaky: true ].
	anItem theValue = self theValue ifFalse: [ self isFlaky: true ]

]
