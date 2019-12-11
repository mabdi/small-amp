Class {
	#name : #SALiteralInputAmplifier,
	#superclass : #SAAbstractInputAmplifier,
	#category : #'Amplification-Core'
}

{ #category : #removing }
SALiteralInputAmplifier >> mutate: aMethod [
	| mutants |
	mutants := DSpotASTMutationRewriter new doYourJob: aMethod.
	^ self renameMutations: mutants
]
