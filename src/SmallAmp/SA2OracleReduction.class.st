Class {
	#name : #SA2OracleReduction,
	#superclass : #SAAbstractOracleReduction,
	#instVars : [
		'particularResults'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #adding }
SA2OracleReduction >> addErrorBlocks: newTree [
	| replace |
	replace := OrderedCollection new.
	(newTree statements select: #isAssignment) do: [ :stmt | 
		newTree body replaceNode: stmt withNode: (RBMessageNode
	receiver:
		(RBBlockNode
			body: (RBSequenceNode statements: {(stmt copy)}))
	selector: #on:do:
	arguments:
		{(RBVariableNode named: #Error).
		(RBBlockNode body: (RBSequenceNode statements: {}))}) 
		 ]
]

{ #category : #running }
SA2OracleReduction >> addLoggerToAllAsserts: aParseTree [
	| id b |
	id := 0.
	b := [ :node | 
	| template |
	template := String
		streamContents: [ :s | 
			s
				nextPutAll: '[ ';
				nextPutAll: node formattedCode;
				nextPutAll: ' ] on: Error do: [ self smallamp_logs: ''';
				nextPutAll: aParseTree selector asString;
				nextPutAll: '.';
				nextPutAll: id asString;
				nextPutAll: '''. self assert: false ]' ].
	id := id + 1.
	RBParser parseExpression: template ].
	^ self getAssertTransformer rewriteAllAssertsIn: aParseTree replaceBlock: b
]

{ #category : #cleanup }
SA2OracleReduction >> cleanUp: generatedClass [
	config debug ifFalse: [ 
		self astHelper removeClass: generatedClass source: self class name ]
]

{ #category : #'as yet unclassified' }
SA2OracleReduction >> getAssertTransformer [
	^ SAAssertTransform new
]

{ #category : #'as yet unclassified' }
SA2OracleReduction >> hasAnySelfCall: newTree [
	"keep if has any msg call to self"

	^ newTree allChildren
		anySatisfy: [ :node | node isMessage and: [ node receiver isSelf ] ]
]

{ #category : #'as yet unclassified' }
SA2OracleReduction >> installLoggers [
	reducedTestClass class addInstVarNamed: 'smallamp_logs'.
	reducedTestClass class addInstVarNamed: 'smallamp_mutant'.
	reducedTestClass class
		compile:
			'smallamp_logs ^ smallamp_logs ifNil: [ smallamp_logs := OrderedCollection new ]  '.
	reducedTestClass class
		compile: 'setMutant: aMutant smallamp_mutant:= aMutant  '.
	reducedTestClass class
		compile:
			'smallamp_logsAdd: aString self smallamp_logs add: (smallamp_mutant -> aString)'.
	reducedTestClass
		compile: 'smallamp_logs: aString  self class smallamp_logsAdd: aString'.
	reducedTestClass
		compile:
			'assert: aBooleanOrBlock description: aStringOrBlock resumable: resumableBoolean
	 aBooleanOrBlock value ifFalse: [ self error: ''assert failed'' ]'.
	reducedTestClass methods
		select: #isTestMethod
		thenDo: [ :theMethod | 
			| newTree |
			newTree := self addLoggerToAllAsserts: theMethod ast.
			self addErrorBlocks: newTree.
			reducedTestClass compile: newTree formattedCode ]
]

{ #category : #'as yet unclassified' }
SA2OracleReduction >> makeReducedResult [
	| logs |
	reducedTestClass := self createDuplicateClass.
	self installLoggers.
	particularResults := self mutalkRunWithLogging: reducedTestClass.
	logs := reducedTestClass smallamp_logs.
	self uninstallLoggers.
	self reduceMehtodsBasedOn: logs.
	^ reducedTestClass
]

{ #category : #'as yet unclassified' }
SA2OracleReduction >> mutalkRunWithLogging: aClass [
	| analysis1 mutantGenerator mutants |
	particularResults := OrderedCollection new.
	mutantGenerator := SmallAmpMutationsGenerationStrategy new.
	analysis1 := MutationTestingAnalysis
		testCasesFrom: {aClass}
		mutating: targetClasses
		using: MutantOperator contents
		with: SortedTestsMethodsRunningMutantEvaluationStrategy new
		with: mutantGenerator.
	mutants := uncovered collect: #mutant.
	analysis1 generateCoverageAnalysis.
	mutants
		do: [ :m | 
			mutantGenerator mutants: {m}.
			aClass setMutant: m.
			analysis1 generateMutations.
			particularResults addAll: analysis1 generateResultsLogger ]
		displayingProgress: 'Oracle reducing mutation' , ' (' , uncovered size asString , ')'.
	^ particularResults
]

{ #category : #'as yet unclassified' }
SA2OracleReduction >> reduceMehtodsBasedOn: listOfPairs [
	reducedTestClass methods
		select: #isTestMethod
		thenDo: [ :theMethod | 
			| newTree |
			newTree := self
				transformBackAndMakeCommentsBaseOn: listOfPairs
				in: theMethod ast.
			self removeErrorBlocks: newTree.
			(self hasAnySelfCall: newTree)
				ifTrue: [ reducedTestClass compile: newTree formattedCode ]
				ifFalse: [ reducedTestClass removeSelector: newTree selector ] ]
]

{ #category : #adding }
SA2OracleReduction >> removeErrorBlocks: newTree [
	| replace |
	replace := OrderedCollection new.
	(newTree statements select: [:stmt | (stmt isMessage) and: [ (stmt selector = #on:do:) and: [(stmt arguments  at:2) statements isEmpty]] ])
		do: [ :stmt | 
			newTree body
				replaceNode: stmt
				withNode: (stmt receiver statements at: 1) copy
					 ]
]

{ #category : #'as yet unclassified' }
SA2OracleReduction >> stripMethod: newTree [
	| last |
	last := 0.
	newTree statements
		withIndexDo: [ :stmt :idx | 
			(stmt allChildren
				anySatisfy: [ :s | s isMessage and: [ s receiver isSelf ] ])
				ifTrue: [ last := idx ] ].
	[ newTree statements size > last ]
		whileTrue: [ newTree statements removeLast ].
	^ newTree formattedCode 
]

{ #category : #running }
SA2OracleReduction >> transformBackAndMakeCommentsBaseOn: listOfIds in: aParseTree [

	| searchFor rewriter parser tree empty toComment testComment |
	toComment := OrderedCollection new.
	rewriter := RBParseTreeRewriter new.
	parser := aParseTree copy.
	parser allChildren do: [ :each | each comments: nil ].
	searchFor := '[`.@assertStatement] on: Error do: [ self smallamp_logs: `#id. self assert: false ] '.
	empty := RBParser parseExpression: ''.
	rewriter addRule:
		(RBBlockReplaceRule searchFor: searchFor replaceWith: [ :node | 
			 | thisId theAssertion |
			 thisId := (((node arguments at: 2) body statements at: 1)
				            arguments at: 1) value.
			 theAssertion := node receiver body statements at: 1.
			 listOfIds
				 detect: [ :p | p value = thisId ]
				 ifFound: [ :p | 
					 toComment add: p key.
					 theAssertion ]
				 ifNone: [ empty ] ]).
	rewriter executeTree: parser.
	tree := rewriter tree.
	testComment := SAPrettyCommentGenerator new methodAST: tree; particularResults: particularResults; toComment: toComment; generateComment.
	(testComment) ifNotNil: [ :x | 
		tree := self astHelper addComment: x toMethodAST: tree ].
	(self synthesisCommentFrom: toComment) ifNotNil: [ :x | 
		tree := self astHelper addComment: x toMethodAST: tree ].
	^ tree
]

{ #category : #'as yet unclassified' }
SA2OracleReduction >> uninstallLoggers [
	reducedTestClass class removeSelector: #smallamp_logs.
	reducedTestClass class removeSelector: #setMutant:.
	reducedTestClass class removeSelector: #smallamp_logsAdd:.
	reducedTestClass removeSelector: #smallamp_logs:.
	reducedTestClass removeSelector: #assert:description:resumable:.
	reducedTestClass class removeInstVarNamed: 'smallamp_logs'.
	reducedTestClass class removeInstVarNamed: 'smallamp_mutant'.
	
]
