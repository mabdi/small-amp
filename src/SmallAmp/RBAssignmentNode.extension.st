Extension { #name : #RBAssignmentNode }

{ #category : #'*SmallAmp' }
RBAssignmentNode >> smallAmpNormalizeWith: aNormalizer assignTo: aVariable [
	^ aNormalizer normalizeAssignment: self assignTo: aVariable
]
