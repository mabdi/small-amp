Class {
	#name : #SALiteralInputAmplifier,
	#superclass : #SAAbstractInputAmplifier,
	#category : #'SmallAmp-Core'
}

{ #category : #removing }
SALiteralInputAmplifier >> amplifyInputs [
	^ SALiteralMutationRewriter runWith: testMethodModel testMethod
]