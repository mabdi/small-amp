Class {
	#name : #SmallAmpMutationsGenerationStrategy,
	#superclass : #MutationsGenerationStrategy,
	#instVars : [
		'mutants',
		'onBeforeMutant',
		'onMutationEvaluation'
	],
	#category : #'SmallAmp-MuTalk Extension'
}

{ #category : #generating }
SmallAmpMutationsGenerationStrategy >> classesAndMetaclassesFrom: modelClasses [
	^ modelClasses
		inject: OrderedCollection new
		into: [ :classes :aClass | 
			classes
				add: aClass;
				add: aClass class.
			classes ]
]

{ #category : #generating }
SmallAmpMutationsGenerationStrategy >> methodsToMutateFrom: aMutationTestingAnalysis [
	^ (self
		classesAndMetaclassesFrom: aMutationTestingAnalysis modelClasses)
		inject: OrderedCollection new
		into: [ :methods :aClass | 
			"(aClass isKindOf: TraitedMetaclass)
				ifTrue: [ methods addAll: aClass baseLocalMethods ]
				ifFalse: [ methods
						addAll: (aClass methods select: [ :m | m traitSource isNil ]) ]."
			methods
				addAll: (aClass methods select: [ :m | m traitSource isNil ]). methods ]
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

{ #category : #accessing }
SmallAmpMutationsGenerationStrategy >> onBeforeMutant [
	^ onBeforeMutant
]

{ #category : #accessing }
SmallAmpMutationsGenerationStrategy >> onBeforeMutant: anObject [
	onBeforeMutant := anObject
]

{ #category : #accessing }
SmallAmpMutationsGenerationStrategy >> onMutationEvaluation [
	^ onMutationEvaluation
]

{ #category : #accessing }
SmallAmpMutationsGenerationStrategy >> onMutationEvaluation: anObject [
	onMutationEvaluation := anObject
]
