Class {
	#name : #SACoverageOracleReduction,
	#superclass : #SAAbstractOracleReduction,
	#instVars : [
		'link'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SACoverageOracleReduction >> installLoggers [
	reducedTestClass class addInstVarNamed: 'smallamp_logs'.
	reducedTestClass class
		compile:
			'smallamp_logs ^ smallamp_logs ifNil: [ smallamp_logs := OrderedCollection new ]  '.
	reducedTestClass class
		compile: 'smallamp_logsAdd: aString self smallamp_logs add: (aString)'.
	reducedTestClass
		compile:
			'assert: aBooleanOrBlock description: aStringOrBlock resumable: resumableBoolean
	 [ aBooleanOrBlock value. self class smallamp_logsAdd: self selector, ''passed'' ] on: Error do: [self class smallamp_logsAdd: self selector, ''killed'']'.
	link := MetaLink new
		metaObject: [ Error new signal: 'executed' ];
		yourself.
	uncovered do: [ :n | n link: self link ]
]

{ #category : #accessing }
SACoverageOracleReduction >> link [
	^ link	
]

{ #category : #'as yet unclassified' }
SACoverageOracleReduction >> makeReducedResult [
	| logs particularResults methods |
	reducedTestClass := self createDuplicateClass.
	self installLoggers.
	methods := reducedTestClass smallAmpAmplifiedMethods collect: #ast.
	methods do: [ :m | self reduceOracleIn: m ].
	reducedTestClass buildSuite run.
	self halt.
	self uninstallLoggers.
	^ reducedTestClass
]

{ #category : #'as yet unclassified' }
SACoverageOracleReduction >> reduceOracleIn: method [
	| covered coveredNodes |
	covered := (method pragmas
		select: [ :p | p selector = SAAbstractSelection defaultInfoPragma ])
		collect: [ :p | p arguments first value ].
	coveredNodes := uncovered
		select: [ :u | covered includes: u smallAmpInfoText ].
	coveredNodes
		do: [ :n | 
			n
				link:
					(MetaLink new
						metaObject: [ Error new signal: 'executed' ];
						yourself) ].
]

{ #category : #'as yet unclassified' }
SACoverageOracleReduction >> uninstallLoggers [
	reducedTestClass class removeSelector: #smallamp_logs.
	reducedTestClass class removeSelector: #smallamp_logsAdd:.
	reducedTestClass removeSelector: #assert:description:resumable:.
	reducedTestClass class removeInstVarNamed: 'smallamp_logs'.
	link uninstall.
]
