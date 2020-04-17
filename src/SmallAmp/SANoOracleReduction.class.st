Class {
	#name : #SANoOracleReduction,
	#superclass : #SAAbstractOracleReduction,
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SANoOracleReduction >> makeReducedResult [
	| res newClass l methods |
	l := [ :cls | cls testSelectors collect: [ :s | (cls methodNamed: s) sourceCode ] ].
	methods := l value: testClass.
	methods := methods , (l value: newTestClass).
	newClass := SAASTHelper new
		buildTestClassWith: methods
		using: testClass.
	res := newClass.
	"res analysis: (self mutalkRun: testClass)."
	^ res
]
