Class {
	#name : #SALiteralInputAmplifier,
	#superclass : #SAAbstractInputAmplifier,
	#category : #'Amplification-Core'
}

{ #category : #removing }
SALiteralInputAmplifier >> amplifyInputs [
	^ SALiteralMutationRewriter runWith: testMethodModel testMethod
]
