Class {
	#name : #SALiteralMutationRewriter,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'mappings',
		'mutator',
		'testBody',
		'aMethodAST'
	],
	#category : #'SmallAmp-Helpers'
}

{ #category : #'instance creation' }
SALiteralMutationRewriter class >> runWith: aTestBody [
	^ self new
		  with: aTestBody;
		  run
]

{ #category : #'instance creation' }
SALiteralMutationRewriter class >> with: aTestBody [
	^ self new
		  with: aTestBody;
		  yourself
]

{ #category : #initialization }
SALiteralMutationRewriter >> initialize [
	mappings := OrderedCollection new.
	mutator := self mutator
]

{ #category : #visiting }
SALiteralMutationRewriter >> mutationsOfArrayNode: anArrayNode [
	^ mutator mutateArrayNode: anArrayNode
]

{ #category : #'as yet unclassified' }
SALiteralMutationRewriter >> mutationsOfLiteralNode: aLiteralNode [
	| nodes sameTypeNodes |
	nodes := mutator mutateNode: aLiteralNode.
	aLiteralNode value isNumber ifTrue: 
	[sameTypeNodes := aMethodAST allChildren
		select: [ :n | n isLiteralNode and: [ n value class = aLiteralNode value class ] ].
	sameTypeNodes reject: [ :x | x value = aLiteralNode value ].
	sameTypeNodes ifNotEmpty: [ nodes add: sameTypeNodes atRandom ]].
	^ nodes
]

{ #category : #accessing }
SALiteralMutationRewriter >> mutator [
	^ SALiteralMutator new
]

{ #category : #'as yet unclassified' }
SALiteralMutationRewriter >> replaceMappings: map on: aMethod [
	| result |
	result := OrderedCollection new.
	map value do: [ :change | 
		| rewriter mClone theCode |
		mClone := aMethod copy.
		rewriter := RBParseTreeRewriter new.
		rewriter replaceTree: map key withTree: change when: [:n | n start = map key start].
		rewriter executeTree: mClone.
		theCode := mClone formattedCode.
		(theCode includesSubstring: '<an unprintable nonliteral value>') 
			ifTrue: [ self error: 'sth is wrong. you shouldnt be here!' ].
		result add: theCode ].
	^ result
]

{ #category : #'as yet unclassified' }
SALiteralMutationRewriter >> run [
	| results |
	aMethodAST := SAASTHelper new parsedMethodFrom: testBody.
	self visitNode: aMethodAST.
	results := OrderedCollection new.
	mappings
		do: [ :map | results addAll: (self replaceMappings: map on: aMethodAST) ].
	^ results
]

{ #category : #visiting }
SALiteralMutationRewriter >> visitArrayNode: anArrayNode [
	| mutants |
	mutants := self mutationsOfArrayNode: anArrayNode.
	mappings add: anArrayNode -> mutants.
	super visitArrayNode: anArrayNode
]

{ #category : #visiting }
SALiteralMutationRewriter >> visitLiteralArrayNode: aRBLiteralArrayNode [
	| mutants |
	mutants := mutator mutateLiteralArrayNode: aRBLiteralArrayNode.
	mappings add: aRBLiteralArrayNode -> mutants.
	aRBLiteralArrayNode isForByteArray ifFalse: [ super visitLiteralArrayNode: aRBLiteralArrayNode ]
]

{ #category : #visiting }
SALiteralMutationRewriter >> visitLiteralNode: aLiteralNode [
	| mutants |
	mutants := self mutationsOfLiteralNode: aLiteralNode.
	mappings add: aLiteralNode -> mutants
]

{ #category : #'instance creation' }
SALiteralMutationRewriter >> with: aTestBody [
	self initialize.
	testBody := aTestBody
]
