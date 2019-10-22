Class {
	#name : #MuTalkMutationOperator,
	#superclass : #AbstractMutationOperator,
	#category : #'Amplification-Core'
}

{ #category : #removing }
MuTalkMutationOperator >> mutate: aMethod [
	| mutations tempClass |
	mutations := OrderedCollection new.
	tempClass := ASTHelper uniqueInstance
		buildAnTestClassWith: {aMethod}
		using: TestCase.
	mutations
		addAll:
			((AllMutationsGenerationStrategy new
				mutationsFor: (tempClass methods detect: [ :mtd | mtd selector beginsWith: 'test' ])
				usingAll: self operators
				logginIn: NullMutationTestingAnalysisLogger new)
				collect: [ :mtd | mtd modifiedSource ]).
	ASTHelper uniqueInstance removeClass: tempClass  source: self class name..
	^ self renameMutations: mutations
]

{ #category : #accesing }
MuTalkMutationOperator >> operators [
	^(MutantOperator allConcreteSubclasses collect: [ :class | class new ])
		asSortedCollection: [ :elem1 :elem2 | elem1 description <= elem2 description ]
]
