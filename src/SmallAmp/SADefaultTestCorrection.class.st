Class {
	#name : #SADefaultTestCorrection,
	#superclass : #SAAbstractTestCorrection,
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SADefaultTestCorrection class >> createMutantFromString: aMutantStringId [

	^ MethodMutation smallAmpFromString: aMutantStringId
]

{ #category : #adding }
SADefaultTestCorrection >> addErrorBlocksAroundAllAssertEqualsIn: aParseTree [

	| valueNode id b rewriter tree parser |
	rewriter := RBParseTreeRewriter new.
	parser := aParseTree copy.
	id := 0.
	b := [ :node | 
	     | template |
	     template := String streamContents: [ :s | 
		                 valueNode := node arguments first isLiteralNode
			                              ifTrue: [ node arguments second ]
			                              ifFalse: [ node arguments first ].

		                 s
			                 nextPutAll: 'self smallamp_logs: (''';
			                 nextPutAll: aParseTree selector asString;
			                 nextPutAll: '::';
			                 nextPutAll: id asString;
			                 nextPutAll: ''' -> ( ';
			                 nextPutAll: valueNode formattedCode;
			                 nextPutAll: '))' ].
	     id := id + 1.
	     RBParser parseExpression: template ].

	self hookAssertionPatterns do: [ :each | 
		rewriter addRule:
			(RBBlockReplaceRule searchFor: each key replaceWith: b) ].
	rewriter executeTree: parser.
	tree := rewriter tree.
	^ tree
]

{ #category : #'as yet unclassified' }
SADefaultTestCorrection >> checkIsGreenTest: selector [

	| res |
	res := self runTestMethod: selector.
	^ res concretePassed isNotEmpty
]

{ #category : #'as yet unclassified' }
SADefaultTestCorrection >> checkTest: selector stillCovers: coverage [

	| originalMethod analysis |
	originalMethod := theClass >> selector.
	analysis := MutationTestingAnalysis
		            for: { (TestCaseReference for: selector in: theClass) }
		            mutating: theClass smallAmpTargetClasses
		            using: self operators
		            with: AllTestsMethodsRunningMutantEvaluationStrategy new
		            with:
		            (SmallAmpMutationsGenerationStrategy new mutants:
			             coverage).
	analysis run.

	^ analysis generalResult aliveMutants isEmpty
]

{ #category : #'as yet unclassified' }
SADefaultTestCorrection >> fixTest: selector [

	| newAst originalMethod testRun |
	originalMethod := theClass >> selector.
	newAst := self updateLiteralsInAssertionsIn: originalMethod ast copy.
	theClass compile: newAst formattedCode.
	testRun := self runTestMethod: selector.
	testRun concretePassed ifEmpty: [ 
		theClass compile: originalMethod sourceCode ].
]

{ #category : #'as yet unclassified' }
SADefaultTestCorrection >> hookAssertionPatterns [

	| result anSAAssertTransform |
	result := OrderedCollection new.
	anSAAssertTransform := SAAssertTransform new.
	result addAll: anSAAssertTransform transformAssertEquals.
	^ result
]

{ #category : #'as yet unclassified' }
SADefaultTestCorrection >> manipulateTestMethod [

	theClass class addInstVarNamed: 'smallamp_logs'.
	theClass class compile:
		'smallamp_logs ^ smallamp_logs ifNil: [ smallamp_logs := OrderedCollection new ]  '.
	theClass class compile:
		'smallamp_logsAdd: aString self smallamp_logs add: (aString)'.
	theClass compile:
		'smallamp_logs: aString  self class smallamp_logsAdd: aString'
]

{ #category : #accesing }
SADefaultTestCorrection >> operators [

	config mutalkUseOriginalOperators
		ifNil: [ ^ MutantOperator contentsAllStopRecursions ]
		ifNotNil: [ ^ MutantOperator contents ]
]

{ #category : #'as yet unclassified' }
SADefaultTestCorrection >> revertManipulatedTestMethod [
	theClass removeSelector: #smallamp_logs:.
	theClass class removeSelector: #smallamp_logs.
	theClass class removeSelector: #smallamp_logsAdd:.
	theClass class removeInstVarNamed: 'smallamp_logs'.
	

]

{ #category : #'as yet unclassified' }
SADefaultTestCorrection >> runTestMethod: selector [

	| r |
	r := SAGenericMethods new
		     runSafelyTestClass: theClass
		     selector: selector
		     timeOut: config testRunTimeOut milliSeconds.
	^ r
]

{ #category : #'as yet unclassified' }
SADefaultTestCorrection >> updateLiteralsInAssertionsIn: originalAST [

	| newAst logs |
	[ 
	self manipulateTestMethod.
	newAst := self addErrorBlocksAroundAllAssertEqualsIn: originalAST copy.
	theClass compile: newAst formattedCode.
	self runTestMethod: originalAST selector.
	logs := theClass smallamp_logs ] ensure: [ 
		self revertManipulatedTestMethod ].
	^ self updateVariablesIn: originalAST copy basedOn: logs
]

{ #category : #'as yet unclassified' }
SADefaultTestCorrection >> updateVariablesIn: aParsedTree basedOn: logs [

	| id b thisLog literalNode |
	id := 0.
	b := [ :node | 
	     literalNode := node arguments first isLiteralNode
		                    ifTrue: [ node arguments first ]
		                    ifFalse: [ node arguments second ].
	     thisLog := logs
		                detect: [ :l | 
		                l key = (aParsedTree selector , '::' , id asString) ]
		                ifNone: [ nil ].
	     thisLog ifNotNil: [ 
		     literalNode isVariable ifTrue: [ 
			     node
				     replaceNode: literalNode
				     withNode: (literalNode class named: thisLog name) ].
		     literalNode isLiteralNode ifTrue: [ 
			     node
				     replaceNode: literalNode
				     withNode: (literalNode class value: thisLog value) ] ].
	     id := id + 1.
	     node ].
	^ SAAssertTransform new
		  rewriteAllAssertsIn: aParsedTree
		  replaceBlock: b
]
