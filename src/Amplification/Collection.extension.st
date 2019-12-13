Extension { #name : #Collection }

{ #category : #'*Amplification' }
Collection >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitCollection: self atDepth: anInteger
]
