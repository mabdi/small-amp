Class {
	#name : #SAObservationCollection,
	#superclass : #SAObservationItem,
	#category : #'Amplification-Model'
}

{ #category : #adding }
SAObservationCollection >> checkFlaky: anItem [
	self theValue doWithIndex: [ :item :index | 
		(self theValue at: index) checkFlaky: (anItem theValue at: index) ]
]
