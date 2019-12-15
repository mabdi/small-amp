Class {
	#name : #SAMuTalkTestCaseMinifier,
	#superclass : #SAAbstractTestCaseMinifier,
	#instVars : [
		'newTestClass',
		'testClass',
		'targetClasses'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #accessing }
SAMuTalkTestCaseMinifier >> astHelper [
	^ SAASTHelper new
]

{ #category : #private }
SAMuTalkTestCaseMinifier >> cleanAndMinifyMethod: methodast [
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

{ #category : #private }
SAMuTalkTestCaseMinifier >> makeAssertImportant: id atMethod: methodast [
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
SAMuTalkTestCaseMinifier >> makeMinifiedAddedClass [
	| l methods |
	l := [ :cls | 
	     cls testSelectors collect: [ :s | 
		     (cls methodNamed: s) sourceCode ] ].
	methods := l value: testClass.
	methods := methods , (l value: minifiedTestClass).
	^ self astHelper
		  buildTestClassWith: methods
		  using: testClass
		  final: true
]

{ #category : #actions }
SAMuTalkTestCaseMinifier >> makeMinifiedClass [
	| logs methods |
	self mutalkRun: newTestClass.
	methods := Dictionary new.
	logs := newTestClass logs.
	logs sort collect: [ :item | item splitOn: ':' ] thenDo: [ :item | 
		methods
			at: (item at: 1) asSymbol
			put: (newTestClass methodNamed: (item at: 1) asSymbol) ast ].
	logs sort collect: [ :item | item splitOn: ':' ] thenDo: [ :item | 
		self
			makeAssertImportant: (item at: 2)
			atMethod: (methods at: (item at: 1) asSymbol) ].
	newTestClass logs removeAll.
	methods values do: [ :m | self cleanAndMinifyMethod: m ].
	^ self astHelper
		  buildTestClassWith:
		  (methods values collect: [ :m | m formattedCode ])
		  using: testClass
		  final: true
]

{ #category : #'as yet unclassified' }
SAMuTalkTestCaseMinifier >> minify [
	| logs methods |
	self mutalkRun: newTestClass.
	methods := Dictionary new.
	logs := newTestClass logs.
	logs sort collect: [ :item | item splitOn: ':' ] thenDo: [ :item | 
		methods
			at: (item at: 1) asSymbol
			put: (newTestClass methodNamed: (item at: 1) asSymbol) ast ].
	logs sort collect: [ :item | item splitOn: ':' ] thenDo: [ :item | 
		self
			makeAssertImportant: (item at: 2)
			atMethod: (methods at: (item at: 1) asSymbol) ].
	newTestClass logs removeAll.
	methods values do: [ :m | self cleanAndMinifyMethod: m ].
	^ self astHelper
		  buildTestClassWith:
		  (methods values collect: [ :m | m formattedCode ])
		  using: testClass
		  final: true
]

{ #category : #'as yet unclassified' }
SAMuTalkTestCaseMinifier >> mutalkRun: aClass [
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
