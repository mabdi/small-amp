Class {
	#name : #SAAbstractOracleReduction,
	#superclass : #Object,
	#instVars : [
		'config',
		'newTestClass',
		'testClass',
		'targetClasses',
		'reducedTestClass',
		'reducedAddedTestClass',
		'ignoredTestMethods',
		'uncovered'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SAAbstractOracleReduction class >> defaultAmplifiedNameTemplate [

	^ 'testAmplified_{1}{2}'
]

{ #category : #'as yet unclassified' }
SAAbstractOracleReduction class >> initializeWith: aConfig [
	^ self new
		  with: aConfig
]

{ #category : #accessing }
SAAbstractOracleReduction >> astHelper [
	^ SAGenericMethods new
]

{ #category : #'as yet unclassified' }
SAAbstractOracleReduction >> createDuplicateClass [

	| l methods suffix|
	l := [ :cls | 
	     cls testSelectors collect: [ :s | 
		     (cls methodNamed: s) sourceCode ] ].
	methods := l value: newTestClass.
	suffix := config ampNamesSuffix ifNotNil: [ config ampNamesSuffix ] ifNil: [ '' ]. 
	^ self astHelper buildTestClassAndLogWith: methods using: testClass suffix: suffix
]

{ #category : #accessing }
SAAbstractOracleReduction >> ignoredTestMethods [
	^ ignoredTestMethods
]

{ #category : #accessing }
SAAbstractOracleReduction >> ignoredTestMethods: anObject [
	ignoredTestMethods := anObject
]

{ #category : #'as yet unclassified' }
SAAbstractOracleReduction >> makeReducedResult [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SAAbstractOracleReduction >> reducedAddedTestClass [
	^ reducedAddedTestClass
]

{ #category : #accessing }
SAAbstractOracleReduction >> reducedTestClass [
	^ reducedTestClass
]

{ #category : #accessing }
SAAbstractOracleReduction >> uncovered [
	^ uncovered
]

{ #category : #accessing }
SAAbstractOracleReduction >> uncovered: anObject [
	uncovered := anObject
]

{ #category : #'instance creation' }
SAAbstractOracleReduction >> with: aConfig [
	self initialize.
	config := aConfig
]

{ #category : #'as yet unclassified' }
SAAbstractOracleReduction >> with: newClass from: originalTestClass target: listTtargetClasses uncovered: aListMutants [
	newTestClass := newClass.
	testClass := originalTestClass.
	targetClasses := listTtargetClasses.
	uncovered := aListMutants
]
