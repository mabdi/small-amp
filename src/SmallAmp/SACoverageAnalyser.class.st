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
		'allBranches'
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

{ #category : #private }
SACoverageAnalyser >> runTests [
	| suite |
	testRunningElapsedTime := Time
		millisecondsToRun: [ suite := TestSuite named: 'Test Suite for Coverage'.
			testCases do: [ :each | each addToSuiteFromSelectors: suite ].
			suite run.
			 ]
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
