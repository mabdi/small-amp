Class {
	#name : #SmallAmpMutationsGenerationStrategy,
	#superclass : #MutationsGenerationStrategy,
	#instVars : [
		'mutants'
	],
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

{ #category : #accessing }
SmallAmpMutationsGenerationStrategy >> mutants [
	^ mutants
]

{ #category : #accessing }
SmallAmpMutationsGenerationStrategy >> mutants: anObject [
	mutants := anObject
]

{ #category : #generating }
SmallAmpMutationsGenerationStrategy >> mutationsFor: aMutationTestingAnalysis loggingIn: aLogger [
	mutants
		ifNil: [ mutants := super mutationsFor: aMutationTestingAnalysis loggingIn: aLogger ].
	^ mutants
]
