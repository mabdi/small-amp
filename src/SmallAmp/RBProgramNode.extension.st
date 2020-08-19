Extension { #name : #RBProgramNode }

{ #category : #'*SmallAmp' }
RBProgramNode >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitRBProgramNode: self atDepth: anInteger
]

{ #category : #'*SmallAmp' }
RBProgramNode >> smallAmpNormalizeWith: aNormalizer assignTo: aVariable [
	^ aNormalizer normalizeNode: self assignTo: aVariable
]

{ #category : #'*SmallAmp' }
RBProgramNode >> smallAmpTagExecuted [
	^ self propertyAt: #tagExecutedSmallAmp put: true
]
