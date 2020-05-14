Extension { #name : #RBMessageNode }

{ #category : #'*SmallAmp' }
RBMessageNode >> smallAmpNormalizeWith: aNormalizer assignTo: aVariable [
	^ aNormalizer normalizeMessageNode: self assignTo: aVariable
]
