Extension { #name : #Fraction }

{ #category : #'*SmallAmp' }
Fraction >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitFraction: self atDepth: anInteger
]
