Class {
	#name : #SAMainLoop,
	#superclass : #Object,
	#instVars : [
		'testClass',
		'targetClasses',
		'testMethods',
		'config'
	],
	#category : #'Amplification-Core'
}

{ #category : #'instance creation' }
SAMainLoop class >> with: aConfig [
	^ self new config: aConfig ; yourself
]

{ #category : #'as yet unclassified' }
SAMainLoop >> assertAmplification: population [
	^ self assertAmplifiers
		  inject: OrderedCollection new
		  into: [ :coll :amplifier | 
			  coll addAll:
				  (amplifier doAssertAmplification: population amplifier: self).
				coll ]
]

{ #category : #asserting }
SAMainLoop >> assertAmplifiers [
	self flag: #TODO. "think about naming. Assertion Amplification is better"
	^ config assertAmplifiers
]

{ #category : #accessing }
SAMainLoop >> astHelper [
	^ ASTHelper new
]

{ #category : #accessing }
SAMainLoop >> config: aConfig [
	config := aConfig 
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
	population := self assertAmplification: population.
	^ population
		collect: [ :obj | 
			SATestMethod
				withClass: obj testClass
				method: (self astHelper cleanUp: obj testMethodModified)
				targets: obj testTargets ]
]

{ #category : #actions }
SAMainLoop >> inputAmplification: tcase [
	| newcodes |
	newcodes := OrderedCollection new.
	self inputAmplifiers do: [ :op | 
		newcodes addAll: (op mutate: tcase testMethodModified) ].
	newcodes := newcodes collect: [ :cod | 
		            tcase clone testMethodModified: cod ].
	^ newcodes
]

{ #category : #'as yet unclassified' }
SAMainLoop >> inputAmplificationAll: aPopulation [
	| newcodes |
	newcodes := OrderedCollection new.
	aPopulation
		do: [ :tcase | 
			newcodes addAll: (self inputAmplification: tcase).
			newcodes add: (tcase clone) ]
		displayingProgress: 'Mutating test cases'.
	^ newcodes
]

{ #category : #accessing }
SAMainLoop >> inputAmplifiers [
	^ config inputAmplifiers
]

{ #category : #accessing }
SAMainLoop >> iterations [
	^ config iterations 
]

{ #category : #actions }
SAMainLoop >> removeAssertion: tcase [
	tcase
		testMethodModified: (self astHelper removeAssertions: tcase testMethod)
]

{ #category : #actions }
SAMainLoop >> selectionFrom: aPopulation alreadySelected: aPopulationAll [
	| selectedTests |
	aPopulation ifEmpty: [ ^ aPopulation  ].
	selectedTests := OrderedCollection new.
	self selectors
		do: [ :sel | 
			selectedTests
				addAll: (sel doSelect: aPopulation selected: aPopulationAll) ].
	^ selectedTests
		collect: [ :obj | 
			SATestMethod
				withClass: obj testClass
				method: (self astHelper cleanUp: obj testMethodModified)
				targets: obj testTargets ]
]

{ #category : #accessing }
SAMainLoop >> selectors [
	self flag: #TODO. "change the name. selector is used to the name of methods. selection is better"
	^ config selectors
]

{ #category : #accessing }
SAMainLoop >> start [
	" Here is the main loop of program."

	| population resultPeople |
	population := OrderedCollection withAll:
		              (testMethods collect: [ :tcase | 
			               SATestMethod
				               withClass: testClass
				               method: tcase
				               targets: targetClasses ]).
	resultPeople := self initialAssertAmplify: population clone.
	(1 to: self iterations)
		do: [ :gen | 
			population
				do: [ :tcase | self removeAssertion: tcase ]
				displayingProgress: 'Removing assertions'.
			population := self inputAmplificationAll: population.
			population := self assertAmplification: population.
			population := self
				              selectionFrom: population
				              alreadySelected: resultPeople.
			resultPeople addAll: population ]
		displayingProgress: 'Main loop'.
	^ self astHelper buildTestClassWith: (resultPeople collect: [ :tcase | tcase testMethod ]) using: testClass
		  
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
