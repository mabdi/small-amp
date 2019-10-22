Class {
	#name : #DSpotMutationOperator,
	#superclass : #AbstractMutationOperator,
	#category : #'Amplification-Core'
}

{ #category : #removing }
DSpotMutationOperator >> mutate: aMethod [
	| mutants |
	mutants := DSpotASTMutationRewriter new doYourJob: aMethod.
	^ self renameMutations: mutants
]
