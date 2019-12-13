Extension { #name : #ByteString }

{ #category : #'*Amplification' }
ByteString >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitByteString: self atDepth: anInteger
]
