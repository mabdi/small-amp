Extension { #name : #CompiledCode }

{ #category : #'*SmallAmp' }
CompiledCode >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
^ aVisitor visitCompiledCode: self atDepth: anInteger
]
