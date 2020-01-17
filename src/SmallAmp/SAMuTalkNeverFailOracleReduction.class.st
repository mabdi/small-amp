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
SAMuTalkNeverFailOracleReduction >> cleanAndMinifyMethod: methodast [
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
	l := [ :cls | 
	     cls testSelectors collect: [ :s | 
		     (cls methodNamed: s) sourceCode ] ].
	methods := l value: newTestClass.
	^ self astHelper
		                          buildTestClassWith: methods
		                          using: testClass
		                          final: true
]

{ #category : #'as yet unclassified' }
SAMuTalkNeverFailOracleReduction >> getAssertTransformer [
	^ SAAssertTransform new
]

{ #category : #'as yet unclassified' }
SAMuTalkNeverFailOracleReduction >> installLoggers [
	minifiedTestClass class addInstVarNamed: 'smallamp_logs'.
	minifiedTestClass class
		compile:
			'logs ^ smallamp_logs ifNil: [ smallamp_logs := OrderedCollection new ]  '.
	minifiedTestClass
		compile: 'smallamp_logs: aString self class logs add: aString'.	
	minifiedTestClass
		compile:
			'assert: aBooleanOrBlock description: aStringOrBlock resumable: resumableBoolean
	 aBooleanOrBlock value ifFalse: [ self error: ''assert failed'' ]'. "TODO: if method exists, first rename it then install this version. in unisitall restore renamed method. "
	minifiedTestClass methods
		select: #isTestMethod
		thenDo: [ :theMethod | 
			| newTree |
			newTree := self addLoggerToAllAsserts: theMethod ast.
			minifiedTestClass compile: newTree formattedCode ]
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
SAMuTalkNeverFailOracleReduction >> makeMinifiedAddedClass [
	| l methods |
	l := [ :cls | cls testSelectors collect: [ :s | (cls methodNamed: s) sourceCode ] ].
	methods := l value: testClass.
	methods := methods , (l value: minifiedTestClass).
	minifiedAddedTestClass := self astHelper
		buildTestClassWith: methods
		using: testClass
		final: true
]

{ #category : #actions }
SAMuTalkNeverFailOracleReduction >> makeMinifiedClass [
	| logs |
	minifiedTestClass := self createDuplicateClass.
	self installLoggers.
	self mutalkRun: minifiedTestClass.
	logs := minifiedTestClass logs.
	self uninstallLoggersBut: logs
]

{ #category : #'as yet unclassified' }
SAMuTalkNeverFailOracleReduction >> makeMinifiedResult [
	| res |
	res := SAResultMinifiedItem new.
	self makeMinifiedClass.
	self makeMinifiedAddedClass.
	res minifier: self class.
	res minifiedClass: self minifiedAddedTestClass.
	res analysis: (self mutalkRun: self minifiedAddedTestClass).
	self cleanUp: minifiedTestClass.
	^ res
]

{ #category : #'as yet unclassified' }
SAMuTalkNeverFailOracleReduction >> mutalkRun: aClass [
	| analysis1 |
	analysis1 := MutationTestingAnalysis
		             testCasesFrom: { aClass }
		             mutating: targetClasses
		             using: MutantOperator contents
		             with:
		             AllTestsMethodsRunningMutantEvaluationStrategy new.
	analysis1 run.
	
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
	minifiedTestClass class removeInstVarNamed: 'smallamp_logs'.
	minifiedTestClass class removeSelector: #logs.
	minifiedTestClass removeSelector: #smallamp_logs:.
	minifiedTestClass removeSelector: #assert:description:resumable:.
	minifiedTestClass methods
		select: #isTestMethod
		thenDo: [ :theMethod | 
			| newTree |
			newTree := self
				removeAllAssertsAndTransformImportants: listOfIds
				in: theMethod ast.
			minifiedTestClass compile: newTree formattedCode ]
]