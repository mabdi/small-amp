Class {
	#name : #SAMuTalkFirstFailOracleReduction,
	#superclass : #SAAbstractOracleReduction,
	#category : #'SmallAmp-Core'
}

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

{ #category : #accessing }
SAMuTalkFirstFailOracleReduction >> astHelper [
	^ SAASTHelper new
]

{ #category : #private }
SAMuTalkFirstFailOracleReduction >> cleanAndReduceMethod: methodast [
	| tobecleaned |
	tobecleaned := OrderedCollection new.
	methodast statements
		select: [ :node | 
			node class = RBMessageNode
				and: [ node receiver name = #self
						and: [ node selector asString endsWith: 'description:' ] ] ]
		thenDo: [ :node | 
			node arguments last value = 'Important Assertions'
				ifTrue: [ 
					node
						selector:
							(node selector asString
								copyWithRegex: 'description\:$'
								matchesReplacedWith: '').
					node arguments  removeLast			
								 ]
				ifFalse: [ tobecleaned add: node ] ].
	methodast statements removeAll: tobecleaned
]

{ #category : #cleanup }
SAMuTalkFirstFailOracleReduction >> cleanUp: generatedClass [
	config debug ifFalse: [ 
		self astHelper removeClass: generatedClass source: self class name ]
]

{ #category : #'as yet unclassified' }
SAMuTalkFirstFailOracleReduction >> createDuplicateClass [
	| l methods |
	l := [ :cls | cls testSelectors collect: [ :s | (cls methodNamed: s) sourceCode ] ].
	methods := l value: newTestClass.
	^ self astHelper
		buildTestClassWith: methods
		using: testClass
		
]

{ #category : #'as yet unclassified' }
SAMuTalkFirstFailOracleReduction >> getAssertTransformer [
	^ SAAssertTransform new
]

{ #category : #'as yet unclassified' }
SAMuTalkFirstFailOracleReduction >> hasAnySelfCall: newTree [
	"keep if has any msg call to self"

	^ newTree allChildren
		anySatisfy: [ :node | node isMessage and: [ node receiver isSelf ] ]
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
		compile:
			'smallamp_logs: aString  self class smallamp_logsAdd: aString'.
	reducedTestClass
		compile:
			'assert: aBooleanOrBlock description: aStringOrBlock resumable: resumableBoolean
	 aBooleanOrBlock value ifFalse: [ self error: ''assert failed'' ]'.
	reducedTestClass methods
		select: #isTestMethod
		thenDo: [ :theMethod | 
			| newTree |
			newTree := self addLoggerToAllAsserts: theMethod ast.
			reducedTestClass compile: newTree formattedCode ]
]

{ #category : #'as yet unclassified' }
SAMuTalkFirstFailOracleReduction >> loggersAreInstalled [
	^ newTestClass methodDict includesKey: #logFailure:
]

{ #category : #private }
SAMuTalkFirstFailOracleReduction >> makeAssertImportant: id atMethod: methodast [
	methodast statements
		do:
			[ :node | 
			(node class = RBMessageNode
				and: [ node receiver name = #self
						and: [ (node selector asString endsWith: 'description:')
								and: [ node arguments last value = (methodast selector asString , ':' , id) ] ] ])
				ifTrue: [ (node arguments at: node arguments size)
						value: 'Important Assertions'
						start: 0
						stop: -1 ] ].
]

{ #category : #'as yet unclassified' }
SAMuTalkFirstFailOracleReduction >> makeReducedAddedClass [
	| l methods |
	l := [ :cls | cls testSelectors collect: [ :s | (cls methodNamed: s) sourceCode ] ].
	methods := (testClass testSelectors
		reject: [ :s | (self ignoredTestMethods collect: #selector) includes: s ])
		collect: [ :s | (testClass methodNamed: s) sourceCode ].
	methods := methods , (l value: reducedTestClass).
	reducedAddedTestClass := self astHelper
		buildTestClassWith: methods
		using: testClass
		
]

{ #category : #actions }
SAMuTalkFirstFailOracleReduction >> makeReducedClass [
	| logs |
	reducedTestClass := self createDuplicateClass.
	self installLoggers.
	self mutalkRunWithLogging: reducedTestClass.
	logs := reducedTestClass smallamp_logs.
	self uninstallLoggersBut: logs.
]

{ #category : #'as yet unclassified' }
SAMuTalkFirstFailOracleReduction >> makeReducedResult [
	| res |
	res := SAResultReducedItem new.
	
	self makeReducedClass.
	self makeReducedAddedClass.
	res reducer: self class.
	res reducedClass: self reducedAddedTestClass.
	res analysis: (self mutalkRun: self reducedAddedTestClass).
	res presentationName: self presentationName.
	self cleanUp: reducedTestClass.
	^ res
]

{ #category : #'as yet unclassified' }
SAMuTalkFirstFailOracleReduction >> mutalkRun: aClass [
	| analysis1 |
	analysis1 := MutationTestingAnalysis
		testCasesFrom: {aClass}
		mutating: targetClasses
		using: MutantOperator contents
		with: SortedTestsMethodsRunningMutantEvaluationStrategy new
		with: SmallAmpMutationsGenerationStrategy new.
	analysis1 run.
	^ analysis1
]

{ #category : #'as yet unclassified' }
SAMuTalkFirstFailOracleReduction >> mutalkRunWithLogging: aClass [
	| analysis1 mutantGenerator |
	mutantGenerator := SmallAmpMutationsGenerationStrategy new.
	analysis1 := MutationTestingAnalysis
		testCasesFrom: {aClass}
		mutating: targetClasses
		using: MutantOperator contents
		with: SortedTestsMethodsRunningMutantEvaluationStrategy new
		with: mutantGenerator.
	(mutantGenerator mutationsFor: analysis1)
		do: [ :m | 
			mutantGenerator mutants: {m}.
			aClass setMutant: m.
			
			analysis1 run ]
]

{ #category : #'as yet unclassified' }
SAMuTalkFirstFailOracleReduction >> presentationName [
	^ 'First Mutation Failed'
]

{ #category : #running }
SAMuTalkFirstFailOracleReduction >> removeAllAssertsAndTransformImportants: listOfIds in: aParseTree [
	| searchFor rewriter parser tree empty toComment |
	toComment := OrderedCollection new.
	rewriter := RBParseTreeRewriter new.
	parser := aParseTree copy.
	searchFor := '[`.@assertStatement] on: Error do: [ self smallamp_logs: `#id. self assert: false ] '.
	empty := RBParser parseExpression: ''.
	rewriter
		addRule:
			(RBBlockReplaceRule
				searchFor: searchFor
				replaceWith: [ :node | 
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
	tree := self astHelper
		addComment: (self synthesisCommentFrom: toComment)
		toMethodAST: tree.
	^ tree
]

{ #category : #'as yet unclassified' }
SAMuTalkFirstFailOracleReduction >> stripMethod: newTree [
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
SAMuTalkFirstFailOracleReduction >> synthesisCommentFrom: toComment [
	^ String
		streamContents: [ :s | 
			s
				nextPutAll: 'I detect: ';
				cr.
			toComment
				do: [ :m | 
					s nextPutAll: m asString.
					s cr ] ]
]

{ #category : #'as yet unclassified' }
SAMuTalkFirstFailOracleReduction >> uninstallLoggersBut: listOfPairs [
	reducedTestClass class removeSelector: #smallamp_logs.
	reducedTestClass class removeSelector: #setMutant:.
	reducedTestClass class removeSelector: #smallamp_logsAdd:.
	reducedTestClass removeSelector: #smallamp_logs:.
	reducedTestClass removeSelector: #assert:description:resumable:.
	reducedTestClass class removeInstVarNamed: 'smallamp_logs'.
	reducedTestClass class removeInstVarNamed: 'smallamp_mutant'.
	reducedTestClass methods
		select: #isTestMethod
		thenDo: [ :theMethod | 
			| newTree |
			newTree := self
				removeAllAssertsAndTransformImportants: listOfPairs
				in: theMethod ast.
			(self hasAnySelfCall: newTree)
				ifTrue: [ reducedTestClass compile: newTree formattedCode ]
				ifFalse: [ reducedTestClass removeSelector: newTree selector ] ]
]
