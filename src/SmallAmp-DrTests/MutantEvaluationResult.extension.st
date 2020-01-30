Extension { #name : #MutantEvaluationResult }

{ #category : #'*SmallAmp-DrTests' }
MutantEvaluationResult >> asResultForDrTest [
	^ DTTestLeaf content: self
]

{ #category : #'*SmallAmp-DrTests' }
MutantEvaluationResult >> drTestsBrowse [
	| browser |
	
	browser := GLMTabulator new.
	browser row: #diff.
	browser transmit
		to: #diff;
		andShow: [ :a | 
			a diff
				display: [ :mutantx | 
					{(RBParser parseMethod: mutantx originalSource) formattedCode.
					(RBParser parseMethod: mutantx modifiedSource)
						formattedCode} ] ].
	browser openOn: mutant
]

{ #category : #'*SmallAmp-DrTests' }
MutantEvaluationResult >> drTestsName [
	^ self mutant printString
]
