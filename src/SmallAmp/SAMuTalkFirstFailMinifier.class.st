Class {
	#name : #SAMuTalkFirstFailMinifier,
	#superclass : #SAAbstractTestCaseMinifier,
	#category : #'SmallAmp-Core'
}

{ #category : #accessing }
SAMuTalkFirstFailMinifier >> astHelper [
	^ SAASTHelper new
]

{ #category : #private }
SAMuTalkFirstFailMinifier >> cleanAndMinifyMethod: methodast [
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

{ #category : #'as yet unclassified' }
SAMuTalkFirstFailMinifier >> createDuplicateClass [
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
SAMuTalkFirstFailMinifier >> getAssertTransformer [
	^ SAAssertTransform new
]

{ #category : #'as yet unclassified' }
SAMuTalkFirstFailMinifier >> installLoggers [
	minifiedTestClass class addInstVarNamed: 'smallamp_logs'.
	minifiedTestClass class
		compile:
			'logs ^ smallamp_logs ifNil: [ smallamp_logs := OrderedCollection new ]  '.
	minifiedTestClass
		compile: 'smallamp_logs: aString self class logs add: aString'.
	minifiedTestClass
		compile:
			'assert: aBooleanOrBlock description: aStringOrBlock resumable: resumableBoolean
	 aBooleanOrBlock value ifFalse: [ self error: ''assert failed'' ]'.
	minifiedTestClass methods
		select: #isTestMethod
		thenDo: [ :theMethod | 
			| newTree |
			newTree := self getAssertTransformer
				addLoggerToAllAsserts: theMethod ast.
			minifiedTestClass compile: newTree formattedCode ]
]

{ #category : #'as yet unclassified' }
SAMuTalkFirstFailMinifier >> loggersAreInstalled [
	^ newTestClass methodDict includesKey: #logFailure:
]

{ #category : #private }
SAMuTalkFirstFailMinifier >> makeAssertImportant: id atMethod: methodast [
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

{ #category : #actions }
SAMuTalkFirstFailMinifier >> makeMinifiedAddedClass [
	| l methods |
	l := [ :cls | 
	     cls testSelectors collect: [ :s | 
		     (cls methodNamed: s) sourceCode ] ].
	methods := l value: testClass.
	methods := methods , (l value: minifiedTestClass).
	minifiedAddedTestClass:=  self astHelper
		  buildTestClassWith: methods
		  using: testClass
		  final: true
]

{ #category : #actions }
SAMuTalkFirstFailMinifier >> makeMinifiedClass [
	| logs |
	minifiedTestClass := self createDuplicateClass.
	self installLoggers.
	self mutalkRun: minifiedTestClass.
	logs := minifiedTestClass logs.
	self uninstallLoggersBut: logs
]

{ #category : #'as yet unclassified' }
SAMuTalkFirstFailMinifier >> mutalkRun: aClass [
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

{ #category : #'as yet unclassified' }
SAMuTalkFirstFailMinifier >> uninstallLoggersBut: listOfIds [

	minifiedTestClass class removeInstVarNamed: 'smallamp_logs'.
	minifiedTestClass class removeSelector: #logs.
	minifiedTestClass removeSelector: #smallamp_logs:.
	minifiedTestClass removeSelector: #assert:description:resumable:.
	minifiedTestClass methods
		select: #isTestMethod
		thenDo: [ :theMethod | 
			| newTree |
			newTree := self getAssertTransformer
				removeAllAssertsAndTransformImportants: listOfIds
				in: theMethod ast.
			minifiedTestClass compile: newTree formattedCode ]
]
