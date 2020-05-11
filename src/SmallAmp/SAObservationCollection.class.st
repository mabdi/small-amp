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
	self theValue
		doWithIndex: [ :item :index | 
			| v |
			v := self theValue at: index.
			anItem theValue size < index
				ifTrue: [ v := nil ].
			v ifNotNil: [ v checkFlaky: (anItem theValue at: index) ] ]
]
