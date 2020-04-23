"
I am a copy of class SAMuTalkFirstFailMinifier. This comment is copied from there, and might not be entirely accurate

Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #SAMuTalkNeverFailOracleReduction,
	#superclass : #SAAbstractOracleReduction,
	#category : #'SmallAmp-Core'
}

{ #category : #running }
SAMuTalkNeverFailOracleReduction >> addLoggerToAllAsserts: aParseTree [
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
				nextPutAll: '''. ]' ].
	id := id + 1.
	RBParser parseExpression: template ].
	^ self getAssertTransformer
		rewriteAllAssertsIn: aParseTree
		replaceBlock: b
]

{ #category : #accessing }
SAMuTalkNeverFailOracleReduction >> astHelper [
	^ SAASTHelper new
]

{ #category : #private }
SAMuTalkNeverFailOracleReduction >> cleanAndReduceMethod: methodast [
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
SAMuTalkNeverFailOracleReduction >> cleanUp: generatedClass [
	config debug ifFalse: [ 
		self astHelper removeClass: generatedClass source: self class name ]
]

{ #category : #'as yet unclassified' }
SAMuTalkNeverFailOracleReduction >> createDuplicateClass [
	| l methods |
	l := [ :cls | cls testSelectors collect: [ :s | (cls methodNamed: s) sourceCode ] ].
	methods := l value: newTestClass.
	^ self astHelper
		buildTestClassWith: methods
		using: testClass
		
]

{ #category : #'as yet unclassified' }
SAMuTalkNeverFailOracleReduction >> getAssertTransformer [
	^ SAAssertTransform new
]

{ #category : #'as yet unclassified' }
SAMuTalkNeverFailOracleReduction >> installLoggers [
	reducedTestClass class addInstVarNamed: 'smallamp_logs'.
	reducedTestClass class
		compile:
			'logs ^ smallamp_logs ifNil: [ smallamp_logs := OrderedCollection new ]  '.
	reducedTestClass
		compile: 'smallamp_logs: aString self class logs add: aString'.	
	reducedTestClass
		compile:
			'assert: aBooleanOrBlock description: aStringOrBlock resumable: resumableBoolean
	 aBooleanOrBlock value ifFalse: [ self error: ''assert failed'' ]'. "TODO: if method exists, first rename it then install this version. in unisitall restore renamed method. "
	reducedTestClass methods
		select: #isTestMethod
		thenDo: [ :theMethod | 
			| newTree |
			newTree := self addLoggerToAllAsserts: theMethod ast.
			reducedTestClass compile: newTree formattedCode ]
]

{ #category : #'as yet unclassified' }
SAMuTalkNeverFailOracleReduction >> loggersAreInstalled [
	^ newTestClass methodDict includesKey: #logFailure:
]

{ #category : #private }
SAMuTalkNeverFailOracleReduction >> makeAssertImportant: id atMethod: methodast [
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
SAMuTalkNeverFailOracleReduction >> makeReducedAddedClass [
	| l methods |
	l := [ :cls | cls testSelectors collect: [ :s | (cls methodNamed: s) sourceCode ] ].
	methods := l value: testClass.
	methods := methods , (l value: reducedTestClass).
	reducedAddedTestClass := self astHelper
		buildTestClassWith: methods
		using: testClass
		
]

{ #category : #actions }
SAMuTalkNeverFailOracleReduction >> makeReducedClass [
	| logs |
	reducedTestClass := self createDuplicateClass.
	self installLoggers.
	self mutalkRun: reducedTestClass.
	logs := reducedTestClass logs.
	self uninstallLoggersBut: logs
]

{ #category : #'as yet unclassified' }
SAMuTalkNeverFailOracleReduction >> makeReducedResult [
	| res |
	
	self makeReducedClass.
	self makeReducedAddedClass.
	res := self reducedAddedTestClass.
	self cleanUp: reducedTestClass.
	^ res
]

{ #category : #'as yet unclassified' }
SAMuTalkNeverFailOracleReduction >> mutalkRun: aClass [
	| analysis1 |
	analysis1 := MutationTestingAnalysis
		testCasesFrom: {aClass}
		mutating: targetClasses
		using: MutantOperator contents
		with: AllTestsMethodsRunningMutantEvaluationStrategy new.
	analysis1 runSmallAmpVerbose.
	^ analysis1
]

{ #category : #running }
SAMuTalkNeverFailOracleReduction >> removeAllAssertsAndTransformImportants: listOfIds in: aParseTree [
	| searchFor rewriter parser tree empty |
	rewriter := RBParseTreeRewriter new.
	parser := aParseTree copy.
	searchFor := '[`.@assertStatement] on: Error do: [ self smallamp_logs: `#id ] '.
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
					(listOfIds includes: thisId)
						ifTrue: [ theAssertion ]
						ifFalse: [ empty ] ]).
	rewriter executeTree: parser.
	tree := rewriter tree.
	^ tree
]

{ #category : #'as yet unclassified' }
SAMuTalkNeverFailOracleReduction >> uninstallLoggersBut: listOfIds [
	reducedTestClass class removeInstVarNamed: 'smallamp_logs'.
	reducedTestClass class removeSelector: #logs.
	reducedTestClass removeSelector: #smallamp_logs:.
	reducedTestClass removeSelector: #assert:description:resumable:.
	reducedTestClass methods
		select: #isTestMethod
		thenDo: [ :theMethod | 
			| newTree |
			newTree := self
				removeAllAssertsAndTransformImportants: listOfIds
				in: theMethod ast.
			reducedTestClass compile: newTree formattedCode ]
]
