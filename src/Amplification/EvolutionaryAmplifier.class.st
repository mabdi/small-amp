Class {
	#name : #EvolutionaryAmplifier,
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
EvolutionaryAmplifier class >> initializeWith: atestClass target: aTarget iterations: anInt [
	| obj |
	obj := self new.
	obj testClass: atestClass.
	obj targetClasses: aTarget.
	obj iterations: anInt.
	^ obj
]

{ #category : #asserting }
EvolutionaryAmplifier >> assertAmplifier [
	^ assertAmplifier
		ifNil: [ assertAmplifier := Carving2AssertAmplifier  new ]
]

{ #category : #accessing }
EvolutionaryAmplifier >> astHelper [
	^ ASTHelper uniqueInstance
]

{ #category : #'as yet unclassified' }
EvolutionaryAmplifier >> doAssertAmplification: population [
	^ self assertAmplifier doAssertAmplification: population amplifier: self
]

{ #category : #actions }
EvolutionaryAmplifier >> doMutation: tcase [
	| newcodes |
	newcodes := PopulationCollection new.
	self mutationOperators
		do: [ :op | newcodes addAll: (op mutate: tcase testMethodModified) ].
	newcodes := newcodes
		collect: [ :cod | tcase clone testMethodModified: cod ].
	^ newcodes
]

{ #category : #'as yet unclassified' }
EvolutionaryAmplifier >> doPopulationMutation: aPopulation [
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
EvolutionaryAmplifier >> doSelection: aPopulation selected: aPopulationAll [
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
EvolutionaryAmplifier >> initialAssertAmplify: aPopulation [
	| population |
	population := aPopulation
		collect: [ :tcase | 
			| noAsserts renamed |
			noAsserts := self astHelper removeAssertions: tcase testMethod.
			renamed := (ASTHelper uniqueInstance
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
EvolutionaryAmplifier >> iterations: anInt [
	iterations := anInt 
]

{ #category : #actions }
EvolutionaryAmplifier >> makeTestClass: aCollection [
	^ self astHelper buildTestClassWith: aCollection using: testClass
]

{ #category : #accessing }
EvolutionaryAmplifier >> mutationOperators [
	"^ {MuTalkMutationOperator new}"
	^ { DSpotMutationOperator new }
]

{ #category : #actions }
EvolutionaryAmplifier >> removeAssertion: tcase [
	tcase
		testMethodModified: (self astHelper removeAssertions: tcase testMethod)
]

{ #category : #accessing }
EvolutionaryAmplifier >> selectors [
	^ selectorOperator
		ifNil: [ selectorOperator := {SmallAmpSelector new.
			} ]
]

{ #category : #accessing }
EvolutionaryAmplifier >> start [
	" Here is the main loop of program."

	| population resultPeople |
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
EvolutionaryAmplifier >> targetClasses [
	^ targetClasses
]

{ #category : #accessing }
EvolutionaryAmplifier >> targetClasses: colTarget [
	targetClasses := colTarget
]

{ #category : #accessing }
EvolutionaryAmplifier >> testClass [
	^ testClass
]

{ #category : #accessing }
EvolutionaryAmplifier >> testClass: atestClass [
	testClass := atestClass
]

{ #category : #accessing }
EvolutionaryAmplifier >> testMethods [
	^ testMethods
]

{ #category : #accessing }
EvolutionaryAmplifier >> testMethods: collTestMethods [
	testMethods := collTestMethods
]
