Class {
	#name : #SANoOracleReduction,
	#superclass : #SAAbstractOracleReduction,
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SANoOracleReduction >> makeReducedResult [
	| res newClass l methods |
	res := SAResultReducedItem new.
	l := [ :cls | cls testSelectors collect: [ :s | (cls methodNamed: s) sourceCode ] ].
	methods := l value: testClass.
	methods := methods , (l value: newTestClass).
	newClass := SAASTHelper new
		buildTestClassWith: methods
		using: testClass.
	res reducer: self class.
	res reducedClass: newClass.
	res analysis: (self mutalkRun: testClass).
	res presentationName: self presentationName.
	^ res
]

{ #category : #'as yet unclassified' }
SANoOracleReduction >> mutalkRun: aClass [
	| analysis1 |
	analysis1 := MutationTestingAnalysis
		testCasesFrom: {aClass}
		mutating: targetClasses
		using: MutantOperator contents
		with: AllTestsMethodsRunningMutantEvaluationStrategy new.
	analysis1 runSmallAmp.
	^ analysis1
]
