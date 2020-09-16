Extension { #name : #Class }

{ #category : #'*SmallAmp' }
Class >> smallAmpDefaultInstantiation [
	^ RBMessageNode
						receiver: (RBVariableNode named: self name)
						selector: #new
]
