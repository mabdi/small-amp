Class {
	#name : #IgnoreFailingTestsMethodsEvaluationStrategy,
	#superclass : #MutantEvaluationStrategy,
	#instVars : [
		'toIgnore'
	],
	#category : #'SmallAmp-MuTalk Extension'
}

{ #category : #'instance creation' }
IgnoreFailingTestsMethodsEvaluationStrategy class >> newWith: aCollection [

	^ self new toIgnore: aCollection; yourself 	
]

{ #category : #initialization }
IgnoreFailingTestsMethodsEvaluationStrategy >> initialize [ 
toIgnore := {}
]

{ #category : #tests }
IgnoreFailingTestsMethodsEvaluationStrategy >> testCasesToEvaluate: aMutation for: aMutantEvaluation [
	"Small Hack! each underline is added in each change. we sort based on number of changes. low to high"

	^ aMutantEvaluation testCases
		reject:
			[ :a | (self toIgnore collect: #selector) includes: a testCase selector ]
]

{ #category : #accessing }
IgnoreFailingTestsMethodsEvaluationStrategy >> toIgnore [
	^ toIgnore
]

{ #category : #accessing }
IgnoreFailingTestsMethodsEvaluationStrategy >> toIgnore: anObject [
	anObject ifNil: [ self halt ].
	toIgnore := anObject
]
