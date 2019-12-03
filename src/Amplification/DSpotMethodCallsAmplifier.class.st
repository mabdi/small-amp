Class {
	#name : #DSpotMethodCallsAmplifier,
	#superclass : #AbstractMutationOperator,
	#category : #'Amplification-Core'
}

{ #category : #removing }
DSpotMethodCallsAmplifier >> mutate: aMethod [
	| mutants |
	"mutants := DSpotASTMutationRewriter new doYourJob: aMethod.
	^ self renameMutations: mutants"
]
