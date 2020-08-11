Extension { #name : #Object }

{ #category : #'*SmallAmp' }
Object >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitObject: self atDepth: anInteger
]

{ #category : #'*SmallAmp' }
Object class >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitClass: self atDepth: anInteger
]

{ #category : #'*SmallAmp' }
Object >> smallAmpMutateWith: aMutator [
	^ aMutator mutateObject: self
]
