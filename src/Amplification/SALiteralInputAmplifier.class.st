Class {
	#name : #SALiteralInputAmplifier,
	#superclass : #SAAbstractInputAmplifier,
	#category : #'Amplification-Core'
}

{ #category : #removing }
SALiteralInputAmplifier >> amplifyInputs [
	^ DSpotASTMutationRewriter new doYourJob: testMethodModel testMethod
]
