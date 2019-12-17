Extension { #name : #Character }

{ #category : #'*SmallAmp' }
Character >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitChar: self atDepth: anInteger
]

{ #category : #'*SmallAmp' }
Character >> smallAmpMutateWith: aMutator [
	^ aMutator mutateCharacter: self
]
