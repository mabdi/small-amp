Extension { #name : #False }

{ #category : #'*SmallAmp' }
False >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitFalse: self atDepth: anInteger
]
