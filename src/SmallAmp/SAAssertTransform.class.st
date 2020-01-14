Class {
	#name : #SAAssertTransform,
	#superclass : #Object,
	#category : #'SmallAmp-Helpers'
}

{ #category : #removing }
SAAssertTransform class >> removeAllAsserts: aParseTree [
	^ self new transformAllAsserts: aParseTree extract: false
]

{ #category : #removing }
SAAssertTransform class >> transformAllAsserts: aParseTree [
	^ self new transformAllAsserts: aParseTree extract: true
]

{ #category : #accessor }
SAAssertTransform >> getAllPatterns [
	| methodsToBeCalled |
	methodsToBeCalled := (self class methodsInProtocol:
		                      'transform pattern') collect: #selector.
	^ methodsToBeCalled
		inject: OrderedCollection new
		into: [ :result :item | 
			result
				addAll: (self perform: item);
				yourself ]
]

{ #category : #running }
SAAssertTransform >> rewriteAllAssertsIn: aParseTree replaceBlock: aBlock [
	| rewriter parser tree |
	rewriter := RBParseTreeRewriter new.
	parser := aParseTree copy.
	self getAllPatterns
		do: [ :each | 
			rewriter
				addRule: (RBBlockReplaceRule searchFor: each key replaceWith: aBlock) ].
	rewriter executeTree: parser.
	tree := rewriter tree.
	^ tree
]

{ #category : #running }
SAAssertTransform >> transformAllAsserts: aParseTree extract: doExtract [
	| rewriter parser empty tree |
	rewriter := RBParseTreeRewriter new.
	parser := aParseTree copy.
	empty := RBParser parseExpression: ''.
	self getAllPatterns do: [ :each | 
		doExtract
			ifTrue: [ rewriter replace: each key with: each value ]
			ifFalse: [ 
				rewriter addRule:
					(RBBlockReplaceRule
						 searchFor: each key
						 replaceWith: [ :node | empty ]) ] ].
	rewriter executeTree: parser.
	tree := rewriter tree.
	
	^ tree
]

{ #category : #'transform pattern' }
SAAssertTransform >> transformAssert [
	^ { 
		  ('self assert: ``@aBooleanOrBlock' -> '``@aBooleanOrBlock value').
		  ('self assert: ``@aBooleanOrBlock description: ``@aStringOrBlock'
		   -> '``@aBooleanOrBlock value').
		  ('self assert: ``@aBooleanOrBlock description: ``@aStringOrBlock resumable: ``@resumableBoolean'
		   -> '``@aBooleanOrBlock value').
		  ('self should: ``@aBooleanOrBlock' -> '``@aBooleanOrBlock value').
		  ('self should: ``@aBooleanOrBlock description: ``@aStringOrBlock'
		   -> '``@aBooleanOrBlock value') }
]

{ #category : #'transform pattern' }
SAAssertTransform >> transformAssertCloseTo [
	^ { 
		  ('self assert: ``@actual closeTo: ``@expected' -> '``@actual closeTo: ``@expected')}
]

{ #category : #'transform pattern' }
SAAssertTransform >> transformAssertCollectionEquals [
	^ { ('self assertCollection: ``@actual equals: ``@expected'
	   -> '``@actual = ``@expected') }
]

{ #category : #'transform pattern' }
SAAssertTransform >> transformAssertCollectionHasSameElements [
	^ { ('self assertCollection: ``@actual hasSameElements: ``@expected'
	   -> '(``@actual difference: ``@expected) isEmpty and: [(``@expected
		difference: (``@actual intersection: ``@expected)) isEmpty]') }
]

{ #category : #'transform pattern' }
SAAssertTransform >> transformAssertCollectionIncludesAll [
	^ { ('self assertCollection: ``@actual includesAll: ``@subcollection'
	   ->
		   '``@actual includesAll: ``@subcollection') }
]

{ #category : #'transform pattern' }
SAAssertTransform >> transformAssertEquals [
	^ { 'self assert: ``@actual equals: ``@expected' -> '``@actual = ``@expected'.
	  'self assert: ``@actual equals: ``@expected description: ``@description' -> '``@actual = ``@expected' }
]

{ #category : #'transform pattern' }
SAAssertTransform >> transformAssertIdenticalTo [
	^ { 'self assert: ``@actual identicalTo: ``@expected' -> '``@expected == ``@actual'}
]

{ #category : #'transform pattern' }
SAAssertTransform >> transformDeny [
	^ { 
		  'self deny: ``@aBooleanOrBlock' -> '``@aBooleanOrBlock value not'.
		  ('self deny: ``@aBooleanOrBlock description: ``@aStringOrBlock'
		   -> '``@aBooleanOrBlock value not').
		  ('self deny: ``@aBooleanOrBlock description: ``@aStringOrBlock resumable: ``@resumableBoolean'
		   -> '``@aBooleanOrBlock value not').
		  ('self shouldnt: ``@aBooleanOrBlock'
		   -> '``@aBooleanOrBlock value not').
		  ('self shouldnt: ``@aBooleanOrBlock description: ``@aStringOrBlock'
		   -> '``@aBooleanOrBlock value not') }
]

{ #category : #'transform pattern' }
SAAssertTransform >> transformDenyCollection [
	^ { 'self denyCollection: ``@actual equals: ``@expected' -> '(``@expected = ``@actual) not'}
]

{ #category : #'transform pattern' }
SAAssertTransform >> transformDenyEquals [
	^ { 'self deny: ``@actual equals: ``@expected' -> '(``@expected = ``@actual) not' }
]

{ #category : #'transform pattern' }
SAAssertTransform >> transformDenyIdenticalTo [
	self flag: #TODO. "check it"
	^ { ('self deny: ``@actual identicalTo: ``@expected'
	   -> '(``@expected == ``@actual) not') }
]

{ #category : #'transform pattern' }
SAAssertTransform >> transformShouldNotTakeMoreThan [
	^ { 'self should: ``@aBlock notTakeMoreThan: ``@aDuration' -> '[``@aBlock value. true] valueWithin: ``@aDuration
		onTimeout: [  false]' }
]

{ #category : #'transform pattern' }
SAAssertTransform >> transformShouldNotTakeMoreThanMilliseconds [
	^ { ('self should: ``@aBlock notTakeMoreThanMilliseconds: ``@anInteger'
	   -> '[``@aBlock value. true] valueWithin: (Duration milliSeconds: ``@anInteger)
		onTimeout: [false]') }
]

{ #category : #'transform pattern' }
SAAssertTransform >> transformShouldRaise [
	^ { 'self should: ``@aBlock raise: ``@anExceptionalEvent' -> '[ ``@aBlock value. false ]
		on: ``@anExceptionalEvent
		do: [ :ex | ex return: true ]'.
	  'self should: ``@aBlock raise: ``@anExceptionalEvent description: ``@qwe' -> '[ ``@aBlock value. false ]
		on: ``@anExceptionalEvent
		do: [ :ex | ex return: true ]' }
]

{ #category : #'transform pattern' }
SAAssertTransform >> transformShouldntRaise [
	^ { 'self shouldnt: ``@aBlock raise: ``@anExceptionalEvent' -> '([ ``@aBlock value. false ]
		on: ``@anExceptionalEvent
		do: [ :ex | ex return: true ]) not'.
	  'self shouldnt: ``@aBlock raise: ``@anExceptionalEvent description: ``@qwe' -> '([ ``@aBlock value. false ]
		on: ``@anExceptionalEvent
		do: [ :ex | ex return: true ]) not' }
]
