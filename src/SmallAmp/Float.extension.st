Extension { #name : #Float }

{ #category : #'*SmallAmp' }
Float >> smallAmpMutateWith: aMutator [
	^ aMutator mutateFloat: self
]
