Extension { #name : #UndefinedObject }

{ #category : #'*Amplification' }
UndefinedObject >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitUndefinedObject: self atDepth: anInteger
]
