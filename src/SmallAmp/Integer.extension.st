Extension { #name : #Integer }

{ #category : #'*SmallAmp' }
Integer >> smallAmpMutateWith: aMutator [
	^ aMutator mutateInteger: self
]
