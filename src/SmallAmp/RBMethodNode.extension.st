Extension { #name : #RBMethodNode }

{ #category : #'*SmallAmp' }
RBMethodNode >> smallAmpIsImpure [

	| allInstanceVars |
	allInstanceVars := self allVariables select: #isInstanceVariable.
	 (allInstanceVars anySatisfy: #isWrite)  ifTrue: [ ^ true ].
^ false "false here means I dont know"
]
