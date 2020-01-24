Extension { #name : #Array }

{ #category : #'*SmallAmp' }
Array >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitCollection: self atDepth: anInteger
]
