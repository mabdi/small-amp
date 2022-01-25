Class {
	#name : #SAPrettyCommentGenerator,
	#superclass : #Object,
	#instVars : [
		'methodAST',
		'particularResults',
		'toComment',
		'onlyAAmp',
		'originalMethod',
		'newCovered'
	],
	#category : #'SmallAmp-Helpers'
}

{ #category : #'as yet unclassified' }
SAPrettyCommentGenerator >> extractNewCovered [

	^ (methodAST pragmas select: [ :pr | 
		   pr selector asString
		   = SAAbstractSelection defaultInfoPragma asString ]) collect: [ 
		  :pr | pr arguments first value ]
]

{ #category : #'as yet unclassified' }
SAPrettyCommentGenerator >> extractOriginalTestMethod [
	^ (methodAST pragmas
		detect: [ :pr | 
		pr selector asString = SAGenericMethods defaultPragmaWithOriginal asString ]
		ifNone: [ ^ nil ])arguments first value.

]

{ #category : #'as yet unclassified' }
SAPrettyCommentGenerator >> generateComment [

	onlyAAmp := methodAST selector endsWith: '_amp'.
	originalMethod := self extractOriginalTestMethod.
	newCovered := self extractNewCovered.

	newCovered ifEmpty: [ ^ self generateCommentForNoCoverageInfo ].
	^ self generateCommentWithCoverageInfo
]

{ #category : #'as yet unclassified' }
SAPrettyCommentGenerator >> generateCommentCoverageItem: newCov [

	| parts mutant when code |
	mutant := (particularResults
		           detect: [ :x | x mutant smallAmpDecoratorText = newCov ]
		           ifNone: [ ^ nil ]) .
	when := self synthesisWhenFor: mutant mutantEvaluation observation.
	code := mutant mutant nodeToMutate formattedCode.
	parts := newCov splitOn: '#'.
	^ self templateCoverageItem format: { 
			  (parts at: 2).
			  (parts at: 3).
			  (parts at: 4).
			  (parts at: 5).
			  (parts at: 1).
			  code.
			  when.
			  newCov }
]

{ #category : #'as yet unclassified' }
SAPrettyCommentGenerator >> generateCommentCoverageItems [
	^ '\n' join: (newCovered collect: [:newC | self generateCommentCoverageItem: newC ])
]

{ #category : #'as yet unclassified' }
SAPrettyCommentGenerator >> generateCommentForNoCoverageInfo [

	^ self templateTextNoCoverageInfo format: { 
			  originalMethod.
			  (onlyAAmp
				   ifTrue: [ self templateChangesOnlyAssertionAmp  ]
				   ifFalse: [ self templateChangesInputAndAssertionAmp ]) }
]

{ #category : #'as yet unclassified' }
SAPrettyCommentGenerator >> generateCommentWithCoverageInfo [

	^ self templateText format: { 
			  originalMethod.
			  (onlyAAmp
				   ifTrue: [ self templateChangesOnlyAssertionAmp ]
				   ifFalse: [ self templateChangesInputAndAssertionAmp ]).
			  (newCovered size = 1
				   ifTrue: [ self templateThisPart ]
				   ifFalse: [ self templateTheseParts ]).
			  self generateCommentCoverageItems }
]

{ #category : #accessing }
SAPrettyCommentGenerator >> methodAST [

	^ methodAST
]

{ #category : #accessing }
SAPrettyCommentGenerator >> methodAST: anObject [

	methodAST := anObject
]

{ #category : #accessing }
SAPrettyCommentGenerator >> particularResults [

	^ particularResults
]

{ #category : #accessing }
SAPrettyCommentGenerator >> particularResults: anObject [

	particularResults := anObject
]

{ #category : #'as yet unclassified' }
SAPrettyCommentGenerator >> purgeDecorators: ast_1 [
	| ast |
	ast := ast_1 copy.
	ast pragmas: (ast pragmas reject: [ :pr | 
			 pr selector asString
			 = SAAbstractSelection defaultInfoPragma asString ]).
	ast pragmas: (ast pragmas reject: [ :pr | 
			 pr selector asString
			 = SAGenericMethods defaultPragmaWithOriginal asString ]).
	^ ast
]

{ #category : #running }
SAPrettyCommentGenerator >> synthesisWhenFor: observations [
	| a |
	observations ifEmpty: [ ^ nil ].
	observations
		keysDo: [ :key | 
			(observations at: key) = SmallInteger maxVal
				ifTrue: [ observations at: key put: 'SmallInteger maxVal' ].
			(observations at: key) = SmallInteger minVal
				ifTrue: [ observations at: key put: 'SmallInteger minVal' ] ].
	a := OrderedCollection new.
	observations associationsDo: [ :k | a add: k ].
	^ a asArray asString 
]

{ #category : #'as yet unclassified' }
SAPrettyCommentGenerator >> templateChangesInputAndAssertionAmp [

	^ 'applying some transformations and regenerating its assertions'
]

{ #category : #'as yet unclassified' }
SAPrettyCommentGenerator >> templateChangesOnlyAssertionAmp [

	^ 'regenerating its assertions'
]

{ #category : #'as yet unclassified' }
SAPrettyCommentGenerator >> templateCoverageItem [

	^ '	*	In `{1}>> #{2}` from {3} to {4}:
			Operation: {5}
			Code snippet: `{6}`
			Variables value: {7}
			Mutant id: {8}'
]

{ #category : #'as yet unclassified' }
SAPrettyCommentGenerator >> templateText [

	^ 'SmallAmp has derived this test from `{1}` by {2}.
	This test can cover {3}:
	{4}'
]

{ #category : #'as yet unclassified' }
SAPrettyCommentGenerator >> templateTextNoCoverageInfo [

	^ 'SmallAmp has derived this test from {1} by {2}.'
]

{ #category : #'as yet unclassified' }
SAPrettyCommentGenerator >> templateTheseParts [

	^ 'these parts'
]

{ #category : #'as yet unclassified' }
SAPrettyCommentGenerator >> templateThisPart [

	^ 'this part'
]

{ #category : #accessing }
SAPrettyCommentGenerator >> toComment [

	^ toComment
]

{ #category : #accessing }
SAPrettyCommentGenerator >> toComment: anObject [

	toComment := anObject
]
