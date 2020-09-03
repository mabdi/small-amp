Extension { #name : #Number }

{ #category : #'*SmallAmp' }
Number >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitNumber: self atDepth: anInteger
]

{ #category : #'*SmallAmp' }
Number >> smallAmpMutateWith: aMutator [
	^ aMutator mutateNumber: self
]
