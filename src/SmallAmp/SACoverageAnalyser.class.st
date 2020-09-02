Class {
	#name : #SACoverageAnalyser,
	#superclass : #Object,
	#instVars : [
		'classes',
		'classesAndMetaclasses',
		'testCases',
		'testRunningElapsedTime',
		'methodsCovered',
		'statementsCovered',
		'branchesCovered',
		'allMethods',
		'allStatements',
		'allBranches',
		'ignoreList',
		'level',
		'currentTestMethod',
		'nodes'
	],
	#category : #'SmallAmp-Helpers'
}

{ #category : #accessing }
SACoverageAnalyser >> allBranches [
	^ allBranches
]

{ #category : #accessing }
SACoverageAnalyser >> allMethods [
	^ allMethods
]

{ #category : #accessing }
SACoverageAnalyser >> allStatements [
	^ allStatements
]

{ #category : #accessing }
SACoverageAnalyser >> branchesCoverage [
	self allBranches isZero ifTrue: [ ^ 0 ].
	^ (100 * self branchesCovered / self allBranches) asInteger
]

{ #category : #accessing }
SACoverageAnalyser >> branchesCovered [
	^ branchesCovered
]

{ #category : #accessing }
SACoverageAnalyser >> classes [
	^ classes
]

{ #category : #accessing }
SACoverageAnalyser >> classes: aCollectionOfClasses [
	classes := aCollectionOfClasses
]

{ #category : #private }
SACoverageAnalyser >> classesAndMetaclasses [
	classesAndMetaclasses
		ifNil: [ classesAndMetaclasses := (classes
				collect: [ :aClass | aClass class ]) asOrderedCollection.
			classesAndMetaclasses addAll: classes ].
	^ classesAndMetaclasses
]

{ #category : #accessing }
SACoverageAnalyser >> covered [
	^ (nodes reject: [ :x | x isEmpty ])
]

{ #category : #accessing }
SACoverageAnalyser >> ignoreList [
	^ ignoreList
]

{ #category : #accessing }
SACoverageAnalyser >> ignoreList: anObject [
	ignoreList := anObject
]

{ #category : #evaluating }
SACoverageAnalyser >> initialize [
	ignoreList := OrderedCollection new.
	level := #branch
]

{ #category : #accessing }
SACoverageAnalyser >> level [
	^ level
]

{ #category : #accessing }
SACoverageAnalyser >> level: anObject [
	level := anObject
]

{ #category : #private }
SACoverageAnalyser >> methods [
	^ self classesAndMetaclasses
		inject: OrderedCollection new
		into: [ :methodReferences :aClass | 
			methodReferences addAll: aClass methods.
			methodReferences ]
]

{ #category : #accessing }
SACoverageAnalyser >> methodsCoverage [
	self allMethods isZero
		ifTrue: [ ^ 0 ].
	
	^ (100 * self methodsCovered / self allMethods) asInteger
]

{ #category : #accessing }
SACoverageAnalyser >> methodsCovered [
	^ methodsCovered
]

{ #category : #accessing }
SACoverageAnalyser >> nodes [
	^ nodes
]

{ #category : #accessing }
SACoverageAnalyser >> nodes: anObject [
	nodes := anObject
]

{ #category : #evaluating }
SACoverageAnalyser >> run [
	| link scopeMethods |
	scopeMethods := self methods.
	link := MetaLink new
		selector: #tagExecuted;
		metaObject: #node;
		yourself.
	[ scopeMethods
		do: [ :m | m ast allChildren do: [ :n | n link: link ] ].
	[ self runTests ]
		ensure: [ link uninstall ] ] valueUnpreemptively.
	methodsCovered := ((scopeMethods collect: #ast)
		select: #hasBeenExecuted) size.
	statementsCovered := ((scopeMethods collect: #ast)
		flatCollect: [ :each | each allStatements select: #hasBeenExecuted ])
		size.
	branchesCovered := ((scopeMethods collect: #ast)
		flatCollect: [ :each | each allSequenceNodes select: #hasBeenExecuted ])
		size.
	allMethods := scopeMethods size.
	allStatements := ((scopeMethods collect: #ast)
		flatCollect: [ :each | each allStatements ]) size.
	allBranches := ((scopeMethods collect: #ast)
		flatCollect: [ :each | each allSequenceNodes ]) size.
	scopeMethods
		do: [ :each | 
			each ast allChildren
				do: [ :node | node removeProperty: #tagExecuted ifAbsent: [  ] ] ].
	
]

{ #category : #evaluating }
SACoverageAnalyser >> runCoverage [
	| link |
	link := MetaLink new
		metaObject: self;
		selector: #tagNodeExecuted:;
		arguments: #(node);
		yourself.
	[ nodes keys do: [ :n | n link: link ].
	[ self runTests ]
		ensure: [ link uninstall ] ] valueUnpreemptively
]

{ #category : #'as yet unclassified' }
SACoverageAnalyser >> runFor: unCovered [
	
	nodes := IdentityDictionary  newFrom: (unCovered 
		collect: [ :x | x -> Set new ]).
	^ self runCoverage
]

{ #category : #private }
SACoverageAnalyser >> runTests [
	| suite |
	testRunningElapsedTime := Time
		millisecondsToRun: [ suite := TestSuite named: 'Test Suite for Coverage'.
			testCases do: [ :each | each addToSuiteFromSelectors: suite ].
			self ignoreList
				do: [ :m | 
					suite tests removeAllSuchThat: [ :item | item selector = m selector ] ].
			testCases
				do:
					[ :each | each announcer when: TestCaseStarted send: #testCaseStarted: to: self ].
			suite run.
			testCases do: [ :each | each announcer unsubscribe: self ] ]
]

{ #category : #accessing }
SACoverageAnalyser >> setNodes [
	| scopeMethods b |
	scopeMethods := self methods.
	b := {(#method -> [ :m | m ast ]).
	(#branch -> [ :m | m ast allSequenceNodes ]).
	(#statement -> [ :m | m ast allSequenceNodes statements ])}
		asDictionary at: self level.
	nodes := IdentityDictionary  newFrom: ((scopeMethods flatCollect: b) collect: [ :x | x ->  Set new ]) 
]

{ #category : #'as yet unclassified' }
SACoverageAnalyser >> smallAmpNewCovered: oldAnalysis [
	^ self covered keys reject: [ :m | oldAnalysis covered keys includes: m ]
]

{ #category : #'as yet unclassified' }
SACoverageAnalyser >> smallAmpScore [
	^ 100.0 *(1  -  (self uncovered size / self nodes size))
]

{ #category : #'as yet unclassified' }
SACoverageAnalyser >> smallAmpUncovered [
	^ self uncovered 
]

{ #category : #accessing }
SACoverageAnalyser >> statementsCoverage [
	self allStatements isZero
		ifTrue: [ ^ 0 ].
	
	^ (100 * self statementsCovered / self allStatements) asInteger
]

{ #category : #accessing }
SACoverageAnalyser >> statementsCovered [
	^ statementsCovered
]

{ #category : #'as yet unclassified' }
SACoverageAnalyser >> tagNodeExecuted: node [
	(nodes at: node) add: currentTestMethod
]

{ #category : #tests }
SACoverageAnalyser >> testCaseStarted: anAnnouncement [
	currentTestMethod := anAnnouncement testCase.

	
]

{ #category : #accessing }
SACoverageAnalyser >> testCases [ ^ testCases
]

{ #category : #accessing }
SACoverageAnalyser >> testCases: aCollectionOfTestCases [
	testCases := aCollectionOfTestCases
]

{ #category : #accessing }
SACoverageAnalyser >> testRunningElapsedTime [
^testRunningElapsedTime
]

{ #category : #accessing }
SACoverageAnalyser >> uncovered [
	^ (nodes select: [ :x | x isEmpty  ]) keys
]
