Extension { #name : #SAObservationObject }

{ #category : #'*SmallAmp-Spec' }
SAObservationObject >> specTreeChildren [
	(theValue reject: #isNil) keysAndValuesDo: [ :k :v | v name: k ].
	^ (theValue reject: #isNil) asOrderedCollection
]
