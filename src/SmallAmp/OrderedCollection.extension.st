Extension { #name : #OrderedCollection }

{ #category : #'*SmallAmp' }
OrderedCollection >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitCollection: self atDepth: anInteger
]
