Class {
	#name : #EvolutionaryAmplifer,
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
EvolutionaryAmplifer class >> initializeWith: atestClass target: aTarget iterations: anInt [
	| obj |
	obj := self new.
	obj testClass: atestClass.
	obj targetClasses: aTarget.
	obj iterations: anInt.
	^ obj
]

{ #category : #asserting }
EvolutionaryAmplifer >> assertAmplifier [
	^ assertAmplifier
		ifNil: [ assertAmplifier := Carving2AssertAmplifier  new ]
]

{ #category : #accessing }
EvolutionaryAmplifer >> astHelper [
	^ ASTHelper uniqueInstance
]

{ #category : #'as yet unclassified' }
EvolutionaryAmplifer >> doAssertAmplification: population [
	^ self assertAmplifier doAssertAmplification: population amplifier: self
]

{ #category : #actions }
EvolutionaryAmplifer >> doMutation: tcase [
	| newcodes |
	newcodes := PopulationCollection new.
	self mutationOperators
		do: [ :op | newcodes addAll: (op mutate: tcase testMethodModified) ].
	newcodes := newcodes
		collect: [ :cod | tcase clone testMethodModified: cod ].
	^ newcodes
]

{ #category : #'as yet unclassified' }
EvolutionaryAmplifer >> doPopulationMutation: aPopulation [
	| newcodes |
	newcodes := PopulationCollection new.
	aPopulation
		do: [ :tcase | 
			newcodes addAll: (self doMutation: tcase).
			newcodes add: (tcase clone) ]
		displayingProgress: 'Mutating test cases'.
	^ newcodes
]

{ #category : #actions }
EvolutionaryAmplifer >> doSelection: aPopulation selected: aPopulationAll [
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
EvolutionaryAmplifer >> initialAssertAmplify: aPopulation [
	| population |
	population := aPopulation
		collect: [ :tcase | 
			tcase
				testMethodModified: (self astHelper removeAssertions: tcase testMethod) ]
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
EvolutionaryAmplifer >> iterations: anInt [
	iterations := anInt 
]

{ #category : #actions }
EvolutionaryAmplifer >> makeTestClass: aCollection [
	^ self astHelper buildAnTestClassWith: aCollection using: testClass
]

{ #category : #accessing }
EvolutionaryAmplifer >> mutationOperators [
	"^ {MuTalkMutationOperator new}"
	^ { DSpotMutationOperator new }
]

{ #category : #actions }
EvolutionaryAmplifer >> removeAssrtion: tcase [
	tcase
		testMethodModified: (self astHelper removeAssertions: tcase testMethod)
]

{ #category : #accessing }
EvolutionaryAmplifer >> selectors [
	^ selectorOperator
		ifNil: [ selectorOperator := {SmallAmpSelector new.
			} ]
]

{ #category : #accessing }
EvolutionaryAmplifer >> start [
	" Here is the main loop of program."

	| population resultPeople |
	EvalLog instanceReset.
	EvalLog newGeneration.
	population := PopulationCollection
		setUpWith:
			(testMethods
				collect: [ :tcase | 
					TestMethodObject
						withClass: testClass
						method: tcase
						targets: targetClasses ]).
	
	resultPeople := self initialAssertAmplify: population clone.
	(1 to: iterations)
		do: [ :gen | 
			EvalLog newGeneration.
			EvalLog tickAt: #time_all.
			EvalLog tickAt: #input_amp.
			population
				do: [ :tcase | self removeAssrtion: tcase ]
				displayingProgress: 'Removing assertions'.
			population := self doPopulationMutation: population.
			EvalLog tickAt: #input_amp.
			EvalLog tickAt: #assert_amp.
			population := self doAssertAmplification: population.
			EvalLog tickAt: #assert_amp.
			EvalLog tickAt: #selection.
			population := self doSelection: population selected: resultPeople.
			resultPeople addAll: population.
			EvalLog tickAt: #selection.
			EvalLog tickAt: #time_all ]
		displayingProgress: 'Main loop'.
	^ self
		makeTestClass: (resultPeople collect: [ :tcase | tcase testMethod ])
]

{ #category : #accessing }
EvolutionaryAmplifer >> targetClasses [
	^ targetClasses
]

{ #category : #accessing }
EvolutionaryAmplifer >> targetClasses: colTarget [
	targetClasses := colTarget
]

{ #category : #accessing }
EvolutionaryAmplifer >> testClass [
	^ testClass
]

{ #category : #accessing }
EvolutionaryAmplifer >> testClass: atestClass [
	testClass := atestClass
]

{ #category : #accessing }
EvolutionaryAmplifer >> testMethods [
	^ testMethods
]

{ #category : #accessing }
EvolutionaryAmplifer >> testMethods: collTestMethods [
	testMethods := collTestMethods
]
