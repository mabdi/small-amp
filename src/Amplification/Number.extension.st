Extension { #name : #Number }

{ #category : #'*Amplification' }
Number >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitNumber: self atDepth: anInteger
]
