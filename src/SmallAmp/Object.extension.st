Extension { #name : #Object }

{ #category : #'*SmallAmp' }
Object >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitObject: self atDepth: anInteger
]
