Extension { #name : #True }

{ #category : #'*SmallAmp' }
True >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitTrue: self atDepth: anInteger
]

{ #category : #'*SmallAmp' }
True >> smallAmpMutateWith: aMutator [
	^ aMutator mutateTrue: self
]
