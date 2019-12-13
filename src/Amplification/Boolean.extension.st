Extension { #name : #Boolean }

{ #category : #'*Amplification' }
Boolean >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitBoolean: self atDepth: anInteger
]
