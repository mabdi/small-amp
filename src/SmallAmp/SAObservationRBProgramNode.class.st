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

{ #category : #adding }
SAObservationRBProgramNode >> checkFlaky: anItem [
	anItem theClass = self theClass
		ifFalse: [ self isFlaky: true ].
	anItem theValue dump = self theValue dump
		ifFalse: [ self isFlaky: true ]
]

{ #category : #accessing }
SAObservationRBProgramNode >> diff: anObject [
	self isFlaky
		ifTrue: [ theClass = anObject theClass
				ifFalse: [ ^ self ] ].
	theValue = anObject theValue
		ifFalse: [ ^ self ].
	^ nil
]

{ #category : #accessing }
SAObservationRBProgramNode >> isEquals: anObject [
	self isFlaky
		ifTrue: [ ^ theClass = anObject theClass ].
	^ theValue = anObject theValue
]

{ #category : #'as yet unclassified' }
SAObservationRBProgramNode >> valueNode [
	^ RBLiteralValueNode
		value: theValue formattedCode
]
