Class {
	#name : #SALiteralInputAmplifier,
	#superclass : #SAAbstractInputAmplifier,
	#category : #'Amplification-Core'
}

{ #category : #removing }
SALiteralInputAmplifier >> amplifyInputs [
	^ SALiteralMutationRewriter new doYourJob: testMethodModel testMethod
]
