Class {
	#name : #SAObservationObject,
	#superclass : #SAObservationValue,
	#category : #'SmallAmp-Model'
}

{ #category : #'as yet unclassified' }
SAObservationObject >> buildAssertions: aGenerator [
	^ aGenerator buildAssertionsObjectObservation: self
]

{ #category : #adding }
SAObservationObject >> checkFlaky: anItem [
	self theValue keysDo: [ :key | 
		(self theValue at: key) checkFlaky: (anItem theValue at: key) 
		 ]
]
