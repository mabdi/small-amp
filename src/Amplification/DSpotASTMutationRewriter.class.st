Class {
	#name : #DSpotASTMutationRewriter,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'mappings',
		'ops'
	],
	#category : #'Amplification-Helpers'
}

{ #category : #'as yet unclassified' }
DSpotASTMutationRewriter >> doYourJob: aMethodSrc [
	| results aMethod |
	results := OrderedCollection new.
	aMethod := RBParser parseMethod: aMethodSrc.
	self visitNode: aMethod.
	mappings do: [ :map | 
		results addAll: (self replaceMappings: map on: aMethod)
		
		 ].
	^ results
]

{ #category : #initialization }
DSpotASTMutationRewriter >> initialize [
	mappings := OrderedCollection new.
	ops := DSpotASTMutation new
]

{ #category : #accessing }
DSpotASTMutationRewriter >> mutationOperators [
	ops ifNil: [ ops := self class subclasses collect: [ :obj | obj new ] ]
]

{ #category : #'as yet unclassified' }
DSpotASTMutationRewriter >> mutationsOfLiteralNode: aLiteralNode [
	^ ops mutateNode: aLiteralNode 
]

{ #category : #'as yet unclassified' }
DSpotASTMutationRewriter >> replaceMappings: map on: aMethod [
	| result |
	result := OrderedCollection new.
	map value
		do: [ :change | 
			| rewriter mClone theCode |
			mClone := aMethod copy.
			rewriter := RBParseTreeRewriter new.
			rewriter replaceTree: map key withTree: change.
			rewriter executeTree: mClone.
			theCode := mClone formattedCode.
			(theCode includesSubstring: '<an unprintable nonliteral value>') ifTrue: [self halt].
			result add: theCode ].
	^ result
]

{ #category : #visiting }
DSpotASTMutationRewriter >> visitLiteralNode: aLiteralNode [
	| mutants |
	mutants := self mutationsOfLiteralNode: aLiteralNode.
	mappings add: aLiteralNode -> mutants
]
