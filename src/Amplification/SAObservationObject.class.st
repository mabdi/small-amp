Class {
	#name : #SAObservationObject,
	#superclass : #SAObservationItem,
	#category : #'Amplification-Model'
}

{ #category : #adding }
SAObservationObject >> checkFlaky: anItem [
	self theValue keysDo: [ :key | 
		(self theValue at: key) checkFlaky: (anItem theValue at: key) 
		 ]
]
