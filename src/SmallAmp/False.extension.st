Extension { #name : #False }

{ #category : #'*SmallAmp' }
False >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitFalse: self atDepth: anInteger
]

{ #category : #'*SmallAmp' }
False >> smallAmpMutateWith: aMutator [
	^ aMutator mutateFalse: self
]
