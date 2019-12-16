Class {
	#name : #SAObservationPrimitive,
	#superclass : #SAObservationObject,
	#category : #'SmallAmp-Model'
}

{ #category : #'instance creation' }
SAObservationPrimitive class >> newFor: theObject atDepth: anInt [
	^ self newForClass: theObject class values: theObject atDepth: anInt
]

{ #category : #'as yet unclassified' }
SAObservationPrimitive >> buildAssertions: aGenerator [
	^ aGenerator buildAssertionsPrimitiveObservation: self
]

{ #category : #adding }
SAObservationPrimitive >> checkFlaky: anItem [
	anItem theClass = self theClass ifFalse: [ self isFlaky: true ].
	anItem theValue = self theValue ifFalse: [ self isFlaky: true ]

]

{ #category : #testing }
SAObservationPrimitive >> isPrimitive [
	^ true
]
