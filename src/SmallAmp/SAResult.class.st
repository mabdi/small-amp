Class {
	#name : #SAResult,
	#superclass : #Object,
	#instVars : [
		'results'
	],
	#category : #'SmallAmp-Model'
}

{ #category : #'as yet unclassified' }
SAResult class >> mutalkTarget: aClass testSuite: aTestSuite [
	| analysis1 |
	analysis1 := MutationTestingAnalysis
		testCasesFrom: aTestSuite
		mutating: aClass
		using: MutantOperator contents
		with: AllTestsMethodsRunningMutantEvaluationStrategy new.
	analysis1 run.
	^ analysis1
]

{ #category : #adding }
SAResult >> addResult: aResultItem for: aTestClass [
	results at: aTestClass name put: aResultItem 
]

{ #category : #adding }
SAResult >> initialize [ 
	results := Dictionary new
]

{ #category : #adding }
SAResult >> results [
	^ results
]
