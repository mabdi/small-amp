Extension { #name : #SAObservationPrimitive }

{ #category : #'*SmallAmp-Spec' }
SAObservationPrimitive >> specTreeChildren [
	^ {  }
]

{ #category : #'*SmallAmp-Spec' }
SAObservationPrimitive >> specTreeName [
^ self name , ' (' , self theClass name, ': ', self theValue asString , ')'
]
