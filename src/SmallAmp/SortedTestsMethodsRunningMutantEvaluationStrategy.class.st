Class {
	#name : #SortedTestsMethodsRunningMutantEvaluationStrategy,
	#superclass : #MutantEvaluationStrategy,
	#category : #SmallAmp
}

{ #category : #evaluating }
SortedTestsMethodsRunningMutantEvaluationStrategy >> testCasesToEvaluate: aMutation for: aMutantEvaluation [
	"Small Hack! each underline is added in each change. we sort based on number of changes. low to high"
	^ aMutantEvaluation testCases sort: [ :a :b | (a testCase selector count: [:x | x = $_]) < (b testCase selector count: [:x | x = $_]) ]
]
