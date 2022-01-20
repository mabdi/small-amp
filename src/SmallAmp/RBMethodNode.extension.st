Extension { #name : #RBMethodNode }

{ #category : #'*SmallAmp' }
RBMethodNode >> smallAmpIsPure [

	^ (self allVariables select: #isInstanceVariable) noneSatisfy: #isWrite
]
