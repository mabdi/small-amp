Class {
	#name : #SAObservationObject,
	#superclass : #SAObservationValue,
	#category : #'SmallAmp-Model'
}

{ #category : #'as yet unclassified' }
SAObservationObject >> buildAssertions: aGenerator [
active
		ifFalse: [ ^ {} ].
	^ theClass smallAmpBuildAssertions: self by: aGenerator
]

{ #category : #adding }
SAObservationObject >> checkFlaky: anItem [
	self theValue
		keysDo: [ :key | 
			| v |
			v := self theValue at: key.
			v ifNotNil: [ v checkFlaky: (anItem theValue at: key) ]
			 ]
]

{ #category : #accessing }
SAObservationObject >> theValue: anObject [
	super theValue: anObject.
	(anObject reject: #isNil) do: [ :item | item parent: self ]
]

{ #category : #'as yet unclassified' }
SAObservationObject >> valueNode [
]
