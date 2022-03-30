Class {
	#name : #SAMuTalkFirstFailOracleReduction,
	#superclass : #SAAbstractOracleReduction,
	#instVars : [
		'particularResults',
		'toComment',
		'reverts',
		'numberOfCompiledMethods',
		'namesMapping',
		'onBeforeMutant',
		'onMutationEvaluation'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #adding }
SAMuTalkFirstFailOracleReduction >> addErrorBlocks: newTree [
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
SAMuTalkFirstFailOracleReduction >> addLoggerToAllAsserts: aParseTree [
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

{ #category : #'as yet unclassified' }
SAMuTalkFirstFailOracleReduction >> checkTestIsCorrect: newTree mutants: mutantsToCheck [

	| testCorrection |
	testCorrection := SADefaultTestCorrection new.
	testCorrection theClass: reducedTestClass.
	testCorrection config: config.
	(testCorrection checkIsGreenTest: newTree selector) ifFalse: [ 
		^ false ].
	^ testCorrection
		  checkTest: newTree selector
		  stillCovers: mutantsToCheck
]

{ #category : #'as yet unclassified' }
SAMuTalkFirstFailOracleReduction >> checkTestIsFixable: newTree mutants: mutantsToCheck [

	| testCorrection theAST |
	testCorrection := SADefaultTestCorrection new.
	testCorrection theClass: reducedTestClass.
	testCorrection config: config.
	theAST := testCorrection updateLiteralsInAssertionsIn: newTree.
	reducedTestClass compile: theAST formattedCode.
	(testCorrection checkIsGreenTest: theAST selector) ifFalse: [ 
		^ false ].
	^ testCorrection
		  checkTest: theAST selector
		  stillCovers: mutantsToCheck
]

{ #category : #cleanup }
SAMuTalkFirstFailOracleReduction >> cleanUp: generatedClass [
	config debug ifFalse: [ 
		self astHelper removeClass: generatedClass source: self class name ]
]

{ #category : #'as yet unclassified' }
SAMuTalkFirstFailOracleReduction >> getAssertTransformer [
	^ SAAssertTransform new
]

{ #category : #'as yet unclassified' }
SAMuTalkFirstFailOracleReduction >> hasAnySelfCall: newTree [

	"keep if has any msg call to self"

	^ newTree allChildren anySatisfy: [ :node | 
		  node isMessage and: [ node receiver isSelfVariable ] ]
]

{ #category : #initialization }
SAMuTalkFirstFailOracleReduction >> initialize [

	toComment := OrderedCollection new.
	reverts := 0.
	numberOfCompiledMethods := 0.
	namesMapping := Dictionary new.
]

{ #category : #'as yet unclassified' }
SAMuTalkFirstFailOracleReduction >> installLoggers [
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

{ #category : #running }
SAMuTalkFirstFailOracleReduction >> makeCommentsIn: aParseTree [

	| tree testComment commentGenerator |
	tree := aParseTree copy.
	commentGenerator := SAPrettyCommentGenerator new
		                    methodAST: tree;
		                    particularResults: particularResults;
		                    toComment: toComment.
	testComment := commentGenerator generateComment.
	tree := commentGenerator purgeDecorators: aParseTree.
	testComment ifNotNil: [ :x | 
		tree := self astHelper addComment: x toMethodAST: tree ].
	^ tree
]

{ #category : #'as yet unclassified' }
SAMuTalkFirstFailOracleReduction >> makeReducedResult [
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
SAMuTalkFirstFailOracleReduction >> mutalkRunWithLogging: aClass [

	| analysis1 mutantGenerator mutants |
	particularResults := OrderedCollection new.
	mutantGenerator := SmallAmpMutationsGenerationStrategy new.
	onBeforeMutant isNotNil & onMutationEvaluation isNotNil ifTrue: [ 
		mutantGenerator
			onBeforeMutant: onBeforeMutant;
			onMutationEvaluation: onMutationEvaluation ].
	analysis1 := MutationTestingAnalysis
		             testCasesFrom: { aClass }
		             mutating: targetClasses
		             using: MutantOperator contents
		             with:
		             SortedTestsMethodsRunningMutantEvaluationStrategy new
		             with: mutantGenerator.
	mutants := uncovered.
	analysis1 generateCoverageAnalysis.
	mutants
		do: [ :m | 
			mutantGenerator onMutationEvaluation ifNotNil: [  
				mutantGenerator onMutationEvaluation value ].
			mutantGenerator onBeforeMutant ifNotNil: [ 
				mutantGenerator onBeforeMutant value: m value: 1 ].
			mutantGenerator mutants: { m }.
			aClass setMutant: m.
			analysis1 generateMutations.
			particularResults addAll: analysis1 generateResultsLogger ]
		displayingProgress:
		'Oracle reducing mutation' , ' (' , uncovered size asString , ')'.
	^ particularResults
]

{ #category : #accessing }
SAMuTalkFirstFailOracleReduction >> namesMapping [

	^ namesMapping
]

{ #category : #accessing }
SAMuTalkFirstFailOracleReduction >> onBeforeMutant [

	^ onBeforeMutant
]

{ #category : #accessing }
SAMuTalkFirstFailOracleReduction >> onBeforeMutant: anObject [

	onBeforeMutant := anObject
]

{ #category : #accessing }
SAMuTalkFirstFailOracleReduction >> onMutationEvaluation [

	^ onMutationEvaluation
]

{ #category : #accessing }
SAMuTalkFirstFailOracleReduction >> onMutationEvaluation: anObject [

	onMutationEvaluation := anObject
]

{ #category : #'as yet unclassified' }
SAMuTalkFirstFailOracleReduction >> reduceMehtodsBasedOn: listOfPairs [

	| isTestCorrect mutantsToCheck isTestFixed ast oldSelector newSelector suffix |
	reducedTestClass methods
		select: #isTestMethod
		thenDo: [ :theMethod | 
			| originalSource newTree |
			originalSource := (newTestClass >> theMethod selector) sourceCode.
			newTree := self transformBackBaseOn: listOfPairs in: theMethod ast.
			newTree := self makeCommentsIn: newTree.
			self removeErrorBlocks: newTree.
			self removeEmptyLines: newTree.
			(self hasAnySelfCall: newTree)
				ifTrue: [ 
					reducedTestClass compile: newTree formattedCode.
					mutantsToCheck := (SADSpotSelection getNewCoveredFor:
						                   (self astHelper parsedMethodFrom:
							                    originalSource)) collect: [ :str | 
						                  SADefaultTestCorrection 
							                  createMutantFromString: str ].
					isTestCorrect := self
						                 checkTestIsCorrect: newTree
						                 mutants: mutantsToCheck.
					isTestCorrect ifFalse: [ 
						isTestFixed := self
							               checkTestIsFixable: newTree
							               mutants: mutantsToCheck.
						isTestFixed ifFalse: [ 
							reverts := reverts + 1.
							config skipNonPretty
								ifTrue: [ reducedTestClass removeSelector: newTree selector ]
								ifFalse: [ reducedTestClass compile: originalSource ] ] ] ]
				ifFalse: [ reducedTestClass removeSelector: newTree selector ] ].
	(reducedTestClass methods select: #isTestMethod) withIndexDo: [ 
		:theMethod 
		:index | 
		ast := theMethod ast.
		oldSelector := ast selector.
		suffix := config ampNamesSuffix
			          ifNil: [ '' ]
			          ifNotNil: [ config ampNamesSuffix, '_' ].
		newSelector := (self class defaultAmplifiedNameTemplate format: { 
				                suffix.
				                index }) asSymbol.

		reducedTestClass removeSelector: oldSelector.

		namesMapping at: oldSelector put: newSelector.
		ast selector: newSelector.
		reducedTestClass compile: ast formattedCode ]
]

{ #category : #'as yet unclassified' }
SAMuTalkFirstFailOracleReduction >> removeEmptyLines: tree [

	| empty toRemove |
	empty := RBParser parseExpression: ''.

	toRemove := tree allChildren select: [ :n | n = empty ].
	toRemove do: [ :n | (n parent statements includes: n) ifTrue: [ n parent statements remove: n ]  ]
]

{ #category : #adding }
SAMuTalkFirstFailOracleReduction >> removeErrorBlocks: newTree [
	| replace |
	replace := OrderedCollection new.
	(newTree statements select: [:stmt | (stmt isMessage) and: [ (stmt selector = #on:do:) and: [(stmt arguments  at:2) statements isEmpty]] ])
		do: [ :stmt | 
			newTree body
				replaceNode: stmt
				withNode: (stmt receiver statements at: 1) copy
					 ]
]

{ #category : #accessing }
SAMuTalkFirstFailOracleReduction >> reverts [
^ reverts
]

{ #category : #'as yet unclassified' }
SAMuTalkFirstFailOracleReduction >> stripMethod: newTree [

	| last |
	last := 0.
	newTree statements withIndexDo: [ :stmt :idx | 
		(stmt allChildren anySatisfy: [ :s | 
			 s isMessage and: [ s receiver isSelfVariable ] ]) ifTrue: [ 
			last := idx ] ].
	[ newTree statements size > last ] whileTrue: [ 
		newTree statements removeLast ].
	^ newTree formattedCode
]

{ #category : #running }
SAMuTalkFirstFailOracleReduction >> synthesisCommentFrom: toComment [
	| when |
	toComment ifEmpty: [ ^ nil ].
	^ String
		streamContents: [ :s | 
			s
				nextPutAll: 'I test correctness of: ';
				cr;
				cr.
			toComment
				do: [ :m | 
					when := self
						synthesisWhenFor:
							(particularResults detect: [ :x | x mutant = m ] ifNone: [ ^ nil]) mutantEvaluation
								observation.
					s
						nextPutAll: '- ';
						nextPutAll: m smallAmpCommentText.
					when
						ifNotNil: [ s
								nextPutAll: ' when ';
								nextPutAll: when ].
					s
						cr;
						cr ] ]
]

{ #category : #running }
SAMuTalkFirstFailOracleReduction >> synthesisWhenFor: observations [
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

{ #category : #running }
SAMuTalkFirstFailOracleReduction >> transformBackBaseOn: listOfIds in: aParseTree [

	| searchFor rewriter parser tree empty toCleanUp |
	toCleanUp := OrderedCollection new.
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
				 ifNone: [ 
					 node parent isAssignment ifTrue: [ toCleanUp add: node parent ].
					 empty ] ]).
	rewriter executeTree: parser.
	tree := rewriter tree.
	toCleanUp ifEmpty: [ ^ tree ].
	tree allChildren do: [ :node | 
		(toCleanUp includes: node) ifTrue: [ node parent removeNode: node ] ].
	^ tree
]

{ #category : #'as yet unclassified' }
SAMuTalkFirstFailOracleReduction >> uninstallLoggers [
	reducedTestClass class removeSelector: #smallamp_logs.
	reducedTestClass class removeSelector: #setMutant:.
	reducedTestClass class removeSelector: #smallamp_logsAdd:.
	reducedTestClass removeSelector: #smallamp_logs:.
	reducedTestClass removeSelector: #assert:description:resumable:.
	reducedTestClass class removeInstVarNamed: 'smallamp_logs'.
	reducedTestClass class removeInstVarNamed: 'smallamp_mutant'.
	
]
