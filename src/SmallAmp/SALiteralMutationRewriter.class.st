Class {
	#name : #SALiteralMutationRewriter,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'mappings',
		'mutator',
		'testBody'
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

{ #category : #'as yet unclassified' }
SALiteralMutationRewriter >> mutationsOfLiteralNode: aLiteralNode [
	^ mutator mutateNode: aLiteralNode
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
		rewriter replaceTree: map key withTree: change.
		rewriter executeTree: mClone.
		theCode := mClone formattedCode.
		(theCode includesSubstring: '<an unprintable nonliteral value>') 
			ifTrue: [ self error: 'sth is wrong. you shouldnt be here!' ].
		result add: theCode ].
	^ result
]

{ #category : #'as yet unclassified' }
SALiteralMutationRewriter >> run [
	| results aMethodAST |
	aMethodAST := SAASTHelper new parsedMethodFrom: testBody.
	self visitNode: aMethodAST.
	results := OrderedCollection new.
	mappings do: [ :map | 
		results addAll: (self replaceMappings: map on: aMethodAST) ].
	^ results
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
