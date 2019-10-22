"
Amplification initializeWithTests: UUIDGeneratorTests target: {UUIDGenerator}




Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	improvmentAlgorithm:		<Object>
	testClass:		<Object>
	testTarget:		<Object>


    Implementation Points
"
Class {
	#name : #Amplification,
	#superclass : #Object,
	#instVars : [
		'improvmentAlgorithm',
		'testMethods',
		'testTargets',
		'testClass',
		'newTestClass'
	],
	#category : #'Amplification-Core'
}

{ #category : #initialization }
Amplification class >> initializeWithTests: dicConfig [
	^ self new initializeWithTests: dicConfig
]

{ #category : #'as yet unclassified' }
Amplification >> classifyMethods [
	testTargets
		do:
			[ :anObjectUnderTest | SAMethodClassifier classifyClass: anObjectUnderTest ]
]

{ #category : #'as yet unclassified' }
Amplification >> cleanAndMinifyMethod: methodast [
	| tobecleaned |
	tobecleaned := OrderedCollection new.
	methodast statements
		select: [ :node | 
			node class = RBMessageNode
				and: [ node receiver name = #self
						and: [ node selector asString endsWith: 'description:' ] ] ]
		thenDo: [ :node | 
			node arguments last value = 'Important Assertions'
				ifTrue: [ 
					node
						selector:
							(node selector asString
								copyWithRegex: 'description\:$'
								matchesReplacedWith: '').
					node arguments  removeLast			
								 ]
				ifFalse: [ tobecleaned add: node ] ].
	methodast statements removeAll: tobecleaned
]

{ #category : #accessing }
Amplification >> initializeWithTests: dicConfig [
	testTargets := dicConfig at: #testTargets.
	testClass := dicConfig at: #testClass.
	testMethods := testClass allTestSelectors.
	improvmentAlgorithm := EvolutionaryAmplifer
		initializeWith: testClass
		target: testTargets
		iterations: (dicConfig at: #GAIteration ifAbsent: 3).
	improvmentAlgorithm testMethods: testMethods
]

{ #category : #actions }
Amplification >> launch [
	self preStartActions.
	self startAmplify.
	^ self postStartActions
]

{ #category : #'as yet unclassified' }
Amplification >> makeAssertImportant: id atMethod: methodast [
	methodast statements
		do:
			[ :node | 
			(node class = RBMessageNode
				and: [ node receiver name = #self
						and: [ (node selector asString endsWith: 'description:')
								and: [ node arguments last value = (methodast selector asString , ':' , id) ] ] ])
				ifTrue: [ (node arguments at: node arguments size)
						value: 'Important Assertions'
						start: 0
						stop: -1 ] ].
]

{ #category : #actions }
Amplification >> makeMinifiedClass [
	| logs methods |
	self mutalkRun: newTestClass target: testTargets.
	methods := Dictionary new.
	logs := newTestClass logs.
	logs sort
		collect: [ :item | item splitOn: ':' ]
		thenDo: [ :item | 
			methods
				at: (item at: 1) asSymbol
				put: (newTestClass methodNamed: (item at: 1) asSymbol) ast ].
	logs sort
		collect: [ :item | item splitOn: ':' ]
		thenDo: [ :item | 
			self
				makeAssertImportant: (item at: 2)
				atMethod: (methods at: (item at: 1) asSymbol) ].
	newTestClass logs removeAll.
	methods values do: [ :m | self cleanAndMinifyMethod: m ].
	^ ASTHelper uniqueInstance
		buildAnTestClassWith: (methods values collect: [ :m | m formattedCode ])
		using: testClass
		final: true
]

{ #category : #'as yet unclassified' }
Amplification >> mutalkRun: aClass [
	| targetClasses analysis1 |
	analysis1 := MutationTestingAnalysis
		testCasesFrom: {aClass}
		mutating: targetClasses
		using: MutantOperator contents
		with: AllTestsMethodsRunningMutantEvaluationStrategy new.
	analysis1 run.
	^ analysis1
]

{ #category : #'as yet unclassified' }
Amplification >> mutalkRun: aClass target: targetClasses [
	|  analysis1 |
	analysis1 := MutationTestingAnalysis
		testCasesFrom: {aClass}
		mutating: targetClasses
		using: MutantOperator contents
		with: AllTestsMethodsRunningMutantEvaluationStrategy new.
	analysis1 run.
	^ analysis1
]

{ #category : #accessing }
Amplification >> newTestClass [
	^ newTestClass
]

{ #category : #actions }
Amplification >> postStartActions [
	| minified |
	minified:= self makeMinifiedClass.
	^ newTestClass
]

{ #category : #actions }
Amplification >> preStartActions [
	| result |
	self classifyMethods. 
	result := testClass suite run.
	testTargets
		do:
			[ :atarg | atarg methods do: [ :mtd | ObservationProxy fixMethod: mtd ] ].
	testMethods := result passed
		collect: [ :passed | 
			(testClass methods detect: [ :m | m selector = passed selector ])
				sourceCode ].
	improvmentAlgorithm testMethods: testMethods
]

{ #category : #actions }
Amplification >> startAmplify [
	newTestClass := improvmentAlgorithm start
]
