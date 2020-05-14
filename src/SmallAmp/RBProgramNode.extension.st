Extension { #name : #RBProgramNode }

{ #category : #'*SmallAmp' }
RBProgramNode >> smallAmpNormalizeWith: aNormalizer assignTo: aVariable [
	^ aNormalizer normalizeNode: self assignTo: aVariable
]
