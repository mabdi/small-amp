Extension { #name : #RBMethodNode }

{ #category : #'*SmallAmp' }
RBMethodNode >> smallAmpIsPure [ 
	^ (self allVariables select: #isInstance) noneSatisfy: #isWrite
]
