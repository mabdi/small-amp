Extension { #name : #Symbol }

{ #category : #'*SmallAmp' }
Symbol >> smallAmpMutateWith: aMutator [
	^ aMutator mutateSymbol: self
]
