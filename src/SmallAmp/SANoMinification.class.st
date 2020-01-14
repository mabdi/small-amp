Class {
	#name : #SANoMinification,
	#superclass : #SAAbstractTestCaseMinifier,
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SANoMinification >> makeMinifiedResult [
	| res |
	res := SAResultMinifiedItem new.
	res minifier: self class.
	res minifiedClass: testClass.
	res analysis: (self mutalkRun: testClass).
	^ res
]

{ #category : #'as yet unclassified' }
SANoMinification >> mutalkRun: aClass [
	| analysis1 |
	analysis1 := MutationTestingAnalysis
		testCasesFrom: {aClass}
		mutating: targetClasses
		using: MutantOperator contents
		with: AllTestsMethodsRunningMutantEvaluationStrategy new.
	analysis1 run.
	^ analysis1
]
