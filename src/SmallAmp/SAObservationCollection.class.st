Class {
	#name : #SAObservationCollection,
	#superclass : #SAObservationObject,
	#category : #'SmallAmp-Model'
}

{ #category : #'as yet unclassified' }
SAObservationCollection >> buildAssertions: aGenerator [
	^ aGenerator buildAssertionsCollectionObservation: self
]

{ #category : #adding }
SAObservationCollection >> checkFlaky: anItem [
	self theValue doWithIndex: [ :item :index | 
		(self theValue at: index) checkFlaky: (anItem theValue at: index) ]
]
