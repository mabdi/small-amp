Extension { #name : #ByteSymbol }

{ #category : #'*SmallAmp' }
ByteSymbol >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitByteSymbol: self atDepth: anInteger
]
