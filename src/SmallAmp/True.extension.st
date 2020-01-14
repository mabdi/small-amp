Extension { #name : #True }

{ #category : #'*SmallAmp' }
True >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitTrue: self atDepth: anInteger
]
