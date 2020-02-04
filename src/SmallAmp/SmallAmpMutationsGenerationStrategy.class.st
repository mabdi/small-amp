Class {
	#name : #SmallAmpMutationsGenerationStrategy,
	#superclass : #MutationsGenerationStrategy,
	#category : #'SmallAmp-MuTalk Extension'
}

{ #category : #generating }
SmallAmpMutationsGenerationStrategy >> methodsToMutateFrom: aMutationTestingAnalysis [
	^ (aMutationTestingAnalysis modelClasses)
		inject: OrderedCollection new
		into: [ :methods :aClass | 
			methods addAll: aClass methods.
			methods ]
]
