Extension { #name : #SAObservationCollection }

{ #category : #'*SmallAmp-Spec' }
SAObservationCollection >> specTreeChildren [
	(theValue reject: #isNil)
		withIndexDo: [ :v :index | v name: 'at_' , index asString ].
	^ (theValue reject: #isNil) asOrderedCollection
]
