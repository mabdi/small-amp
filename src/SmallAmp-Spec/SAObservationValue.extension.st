Extension { #name : #SAObservationValue }

{ #category : #'*SmallAmp-Spec' }
SAObservationValue >> specTreeChildren [
	^ (theValue reject: #isNil) asOrderedCollection
]

{ #category : #'*SmallAmp-Spec' }
SAObservationValue >> specTreeName [
	^ self name , ' (' , self theClass name , ')'
]
