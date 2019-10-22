Class {
	#name : #AssertTransform,
	#superclass : #Object,
	#category : #'Amplification-Helpers'
}

{ #category : #removing }
AssertTransform class >> convertAllToAssert: aParseTree transformers: collTransformers [
	| rewriter parser |
	rewriter := RBParseTreeRewriter new.
	parser := aParseTree copy.
	collTransformers
		do: [ :each | 
			each findPattern
				do: [ :ptrn | rewriter replace: ptrn with: each changeToAssertPattern ]].
	rewriter executeTree: parser.
	^ rewriter tree
]

{ #category : #removing }
AssertTransform class >> removeAssertions: aParseTree transformers: collTransformers [
	| rewriter parser |
	rewriter := RBParseTreeRewriter new.
	parser := aParseTree copy.
	collTransformers
		do: [ :each | 
			each findPattern
				do: [ :ptrn | rewriter replace: ptrn with: each assertPattern ] ].
	rewriter executeTree: parser.
	^ rewriter tree
]

{ #category : #removing }
AssertTransform class >> removeAssertionsNoExtract: aParseTree transformers: collTransformers [
	| rewriter parser empty|
	rewriter := RBParseTreeRewriter new.
	parser := aParseTree copy.
	empty:= RBParser parseExpression: ''.
	collTransformers
		do: [ :each | 
			each findPattern
				do: [ :ptrn | 
					rewriter addRule: (RBBlockReplaceRule searchFor: ptrn replaceWith: [:node | empty ]) ] ].
	rewriter executeTree: parser.
	^ rewriter tree
]

{ #category : #running }
AssertTransform >> assertPattern [
	self subclassResponsibility
]

{ #category : #running }
AssertTransform >> changeToAssertPattern [
	^ 'self assert: (' , self assertPattern , ')'
]

{ #category : #'mutant generation' }
AssertTransform >> doNormalization: aParseTree [
	| rewriter parser |
	rewriter := RBParseTreeRewriter new.
	parser := aParseTree copy.
	rewriter replace: self findPattern with: self changeToAssertPattern.
	rewriter executeTree: parser.
	^ rewriter tree
]

{ #category : #'mutant generation' }
AssertTransform >> doNormalizationGetCode: aParseTree [
	^ (self doNormalization: aParseTree) formattedCode 
]

{ #category : #running }
AssertTransform >> findPattern [
	self subclassResponsibility
]

{ #category : #'mutant generation' }
AssertTransform >> removeAssertions: aParseTree [
	| rewriter parser |
	rewriter := RBParseTreeRewriter new.
	parser := aParseTree copy.
	rewriter replace: self findPattern with: self assertPattern.
	rewriter executeTree: parser.
	^ rewriter tree
]
