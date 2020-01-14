Extension { #name : #Number }

{ #category : #'*SmallAmp' }
Number >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitNumber: self atDepth: anInteger
]
