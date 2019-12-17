Extension { #name : #ByteString }

{ #category : #'*SmallAmp' }
ByteString >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitByteString: self atDepth: anInteger
]

{ #category : #'*SmallAmp' }
ByteString >> smallAmpMutateWith: aMutator [
	^ aMutator mutateString: self
]
