Extension { #name : #RBCascadeNode }

{ #category : #'*SmallAmp' }
RBCascadeNode >> smallAmpNormalizeWith: aNormalizer assignTo: aVariable [
	^ aNormalizer normalizeCascadeNode: self assignTo: aVariable
]
