Extension { #name : #UndefinedObject }

{ #category : #'*SmallAmp' }
UndefinedObject >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitUndefinedObject: self atDepth: anInteger
]
