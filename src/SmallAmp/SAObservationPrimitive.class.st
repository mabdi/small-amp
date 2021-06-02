Class {
	#name : #SAObservationPrimitive,
	#superclass : #SAObservationValue,
	#category : #'SmallAmp-Model'
}

{ #category : #'instance creation' }
SAObservationPrimitive class >> newFor: theObject atDepth: anInt [
	^ self newForClass: theObject class values: theObject atDepth: anInt
]

{ #category : #'as yet unclassified' }
SAObservationPrimitive >> buildAssertions: aGenerator [
active
		ifFalse: [ ^ {} ].
	^ aGenerator buildAssertionsPrimitiveObservation: self
]

{ #category : #adding }
SAObservationPrimitive >> checkFlaky: anItem [
	anItem theClass = self theClass ifFalse: [ self isFlaky: true ].
	anItem theValue = self theValue ifFalse: [ self isFlaky: true ]

]

{ #category : #testing }
SAObservationPrimitive >> diff: anObject [
	self isFlaky
		ifTrue: [ theClass = anObject theClass ifFalse: [ ^ self ] ].
	theValue = anObject theValue ifFalse: [ ^ self ].
	^ nil
	
]

{ #category : #testing }
SAObservationPrimitive >> isEquals: anObject [
	self isFlaky
		ifTrue: [ ^ theClass = anObject theClass ].
	^ theValue = anObject theValue
		
]

{ #category : #testing }
SAObservationPrimitive >> isPrimitive [
	^ true
]

{ #category : #'as yet unclassified' }
SAObservationPrimitive >> valueNode [
	^ RBLiteralValueNode value: theValue 
]
