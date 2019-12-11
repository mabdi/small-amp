Class {
	#name : #SAMainLoop,
	#superclass : #Object,
	#instVars : [
		'testClass',
		'targetClasses',
		'testMethods',
		'iterations',
		'assertAmplifier',
		'selectorOperator'
	],
	#category : #'Amplification-Core'
}

{ #category : #initialization }
SAMainLoop class >> initializeWith: atestClass target: aTarget iterations: anInt [
	| obj |
	obj := self new.
	obj testClass: atestClass.
	obj targetClasses: aTarget.
	obj iterations: anInt.
	^ obj
]

{ #category : #asserting }
SAMainLoop >> assertAmplifier [
	^ assertAmplifier
		ifNil: [ assertAmplifier := CarvingAssertAmplifier  new ]
]

{ #category : #accessing }
SAMainLoop >> astHelper [
	^ ASTHelper new
]

{ #category : #'as yet unclassified' }
SAMainLoop >> doAssertAmplification: population [
	^ self assertAmplifier doAssertAmplification: population amplifier: self
]

{ #category : #actions }
SAMainLoop >> doMutation: tcase [
	| newcodes |
	newcodes := OrderedCollection new.
	self mutationOperators
		do: [ :op | newcodes addAll: (op mutate: tcase testMethodModified) ].
	newcodes := newcodes
		collect: [ :cod | tcase clone testMethodModified: cod ].
	^ newcodes
]

{ #category : #'as yet unclassified' }
SAMainLoop >> doPopulationMutation: aPopulation [
	| newcodes |
	newcodes := OrderedCollection new.
	aPopulation
		do: [ :tcase | 
			newcodes addAll: (self doMutation: tcase).
			newcodes add: (tcase clone) ]
		displayingProgress: 'Mutating test cases'.
	^ newcodes
]

{ #category : #actions }
SAMainLoop >> doSelection: aPopulation selected: aPopulationAll [
	| selectedTests |
	aPopulation ifEmpty: [ ^ aPopulation  ].
	selectedTests := OrderedCollection new.
	self selectors
		do: [ :sel | 
			selectedTests
				addAll: (sel doSelect: aPopulation selected: aPopulationAll) ].
	^ selectedTests
		collect: [ :obj | 
			TestMethodObject
				withClass: obj testClass
				method: (self astHelper cleanUp: obj testMethodModified)
				targets: obj testTargets ]
]

{ #category : #'as yet unclassified' }
SAMainLoop >> initialAssertAmplify: aPopulation [
	| population |
	population := aPopulation
		collect: [ :tcase | 
			| noAsserts renamed |
			noAsserts := self astHelper removeAssertions: tcase testMethod.
			renamed := (ASTHelper new
				renameMethodName: noAsserts
				append: '_amp') formattedCode.
			tcase testMethodModified: renamed ]
		displayingProgress: 'Removing assertions'.
	population := self doAssertAmplification: population.
	^ population
		collect: [ :obj | 
			TestMethodObject
				withClass: obj testClass
				method: (self astHelper cleanUp: obj testMethodModified)
				targets: obj testTargets ]
]

{ #category : #accessing }
SAMainLoop >> iterations: anInt [
	iterations := anInt 
]

{ #category : #actions }
SAMainLoop >> makeTestClass: aCollection [
	^ self astHelper buildTestClassWith: aCollection using: testClass
]

{ #category : #accessing }
SAMainLoop >> mutationOperators [
	"^ {MuTalkMutationOperator new}"
	^ { DSpotMutationOperator new }
]

{ #category : #actions }
SAMainLoop >> removeAssertion: tcase [
	tcase
		testMethodModified: (self astHelper removeAssertions: tcase testMethod)
]

{ #category : #accessing }
SAMainLoop >> selectors [
	^ selectorOperator
		ifNil: [ selectorOperator := {SmallAmpSelector new.
			} ]
]

{ #category : #accessing }
SAMainLoop >> start [
	" Here is the main loop of program."

	| population resultPeople |
	population := OrderedCollection
		withAll:
			(testMethods
				collect: [ :tcase | 
					TestMethodObject
						withClass: testClass
						method: tcase
						targets: targetClasses ]).
					
	resultPeople := self initialAssertAmplify: population clone.
	(1 to: iterations)
		do: [ :gen | 
			population
				do: [ :tcase | self removeAssertion: tcase ]
				displayingProgress: 'Removing assertions'.
			population := self doPopulationMutation: population.
			population := self doAssertAmplification: population.
			population := self doSelection: population selected: resultPeople.
			resultPeople addAll: population.
			 ]
		displayingProgress: 'Main loop'.
	^ self
		makeTestClass: (resultPeople collect: [ :tcase | tcase testMethod ])
]

{ #category : #accessing }
SAMainLoop >> targetClasses [
	^ targetClasses
]

{ #category : #accessing }
SAMainLoop >> targetClasses: colTarget [
	targetClasses := colTarget
]

{ #category : #accessing }
SAMainLoop >> testClass [
	^ testClass
]

{ #category : #accessing }
SAMainLoop >> testClass: atestClass [
	testClass := atestClass
]

{ #category : #accessing }
SAMainLoop >> testMethods [
	^ testMethods
]

{ #category : #accessing }
SAMainLoop >> testMethods: collTestMethods [
	testMethods := collTestMethods
]
