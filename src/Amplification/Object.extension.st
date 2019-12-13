Extension { #name : #Object }

{ #category : #'*Amplification' }
Object >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitObject: self atDepth: anInteger
]
