Class {
	#name : #SARemoveInputAmplifier,
	#superclass : #SAAbstractInputAmplifier,
	#category : #'SmallAmp-Core'
}

{ #category : #removing }
SARemoveInputAmplifier >> amplifyInputs [
	^ SARemoveMessageRewriter runWith: testMethodModel testMethod
]
