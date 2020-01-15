Class {
	#name : #SANoMinification,
	#superclass : #SAAbstractTestCaseMinifier,
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SANoMinification >> makeMinifiedResult [
	| res newClass l methods |
	res := SAResultMinifiedItem new.
	l := [ :cls | cls testSelectors collect: [ :s | (cls methodNamed: s) sourceCode ] ].
	methods := l value: testClass.
	methods := methods , (l value: newTestClass).
	newClass := SAASTHelper new
		buildTestClassWith: methods
		using: testClass
		final: true.
	res minifier: self class.
	res minifiedClass: newClass.
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
