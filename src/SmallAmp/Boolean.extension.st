Extension { #name : #Boolean }

{ #category : #'*SmallAmp' }
Boolean >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitBoolean: self atDepth: anInteger
]
