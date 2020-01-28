Extension { #name : #BlockClosure }

{ #category : #'*SmallAmp' }
BlockClosure >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitBlockClosure: self atDepth: anInteger
]
