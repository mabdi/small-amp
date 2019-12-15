Extension { #name : #Collection }

{ #category : #'*SmallAmp' }
Collection >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitCollection: self atDepth: anInteger
]
