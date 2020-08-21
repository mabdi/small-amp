Extension { #name : #RBProgramNode }

{ #category : #'*SmallAmp' }
RBProgramNode >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitRBProgramNode: self atDepth: anInteger
]

{ #category : #'*SmallAmp' }
RBProgramNode >> smallAmpInfoText [
	^ ''
		join:
			{self methodNode selector.
			' ('.
			self start.
			':'.
			self stop.
			')'}
]

{ #category : #'*SmallAmp' }
RBProgramNode >> smallAmpNormalizeWith: aNormalizer assignTo: aVariable [
	^ aNormalizer normalizeNode: self assignTo: aVariable
]
