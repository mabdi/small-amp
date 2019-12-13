Extension { #name : #Character }

{ #category : #'*Amplification' }
Character >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitChar: self atDepth: anInteger
]
