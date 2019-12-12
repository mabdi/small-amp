Class {
	#name : #SAMainLoop,
	#superclass : #Object,
	#instVars : [
		'testClass',
		'targetClasses',
		'population',
		'config',
		'newTestClass'
	],
	#category : #'Amplification-Core'
}

{ #category : #'instance creation' }
SAMainLoop class >> with: aConfig for: aTestClass targets: targetClasses [
	^ self new
		  config: aConfig;
		testClass: aTestClass ;
		targetClasses: targetClasses;  
		  yourself
]

{ #category : #accessing }
SAMainLoop >> amplify [
	| resultPeople |
	self methodProfiling.
	resultPeople := self initialAssertionAmplify.
	config lite ifFalse: [ 
		(1 to: config iterations)
			do: [ :gen | 
				self strip.
				self inputAmplification.
				self assertionAmplification.
				self selectionAlreadySelected: resultPeople.
				resultPeople addAll: population ]
			displayingProgress: 'Main loop' ].
	^ self makeResult: resultPeople
]

{ #category : #private }
SAMainLoop >> assertionAmplification [
	population
		do: [ :tcase | 
			self assertAmplifiers do: [ :amplifier | 
				tcase assertAmplifyBy: amplifier ] ]
		displayingProgress: 'Assertion Amplification'
]

{ #category : #asserting }
SAMainLoop >> assertionAmplifiers [
	^ config assertionAmplifiers
]

{ #category : #accessing }
SAMainLoop >> astHelper [
	^ ASTHelper new
]

{ #category : #accessing }
SAMainLoop >> config: aConfig [
	config := aConfig 
]

{ #category : #actions }
SAMainLoop >> discardFailingTests [
	| result testMethods |
	result := testClass suite run.
	self flag: #TODO. "Warn if there is failing tests"
	testMethods := result passed collect: [ :passed | 
		               (testClass methodNamed: passed selector) sourceCode ].
	population := testMethods collect: [ :tcase | 
		              SATestMethod
			              with: tcase class: testClass
			              targets: targetClasses ]
]

{ #category : #private }
SAMainLoop >> initialAssertionAmplify [
	| aPopulation |
	aPopulation := population collect: [ :tcase | 
		               tcase renamedCopy: '_amp' ].
	aPopulation do: [ :tcase | tcase strip ].
	aPopulation
		do: [ :tcase | 
			self assertionAmplifiers do: [ :amplifier | 
				tcase assertionAmplifyBy: amplifier ].
			tcase cleanup ]
		displayingProgress: 'Assertion Amplification'.
	^ aPopulation
]

{ #category : #private }
SAMainLoop >> inputAmplification [
	| newcodes |
	newcodes := OrderedCollection new.
	population
		do: [ :tcase | 
			newcodes addAll: (self inputAmplificationMethod: tcase).
			newcodes add: tcase clone ]
		displayingProgress: 'Input Amplification'.
	^ newcodes
]

{ #category : #actions }
SAMainLoop >> inputAmplificationMethod: tcase [
	| newcodes |
	newcodes := OrderedCollection new.
	self inputAmplifiers do: [ :op | 
		newcodes addAll: (op mutate: tcase testMethod) ].
	newcodes := newcodes collect: [ :cod | 
		            tcase clone testMethod: cod ].
	^ newcodes
]

{ #category : #accessing }
SAMainLoop >> inputAmplifiers [
	^ config inputAmplifiers
]

{ #category : #private }
SAMainLoop >> makeResult: resultPeople [
	self flag: #TODO.
	newTestClass := self astHelper
		                buildTestClassWith:
		                (resultPeople collect: [ :tcase | tcase testMethod ])
		                using: testClass.
	^ SAResultItem new
]

{ #category : #private }
SAMainLoop >> methodProfiling [
	targetClasses do: [ :anObjectUnderTest | 
		SAMethodProfiler classifyClass: anObjectUnderTest ]
]

{ #category : #accessing }
SAMainLoop >> newTestClass [
	^ newTestClass
]

{ #category : #actions }
SAMainLoop >> selectionAlreadySelected: aPopulationAll [
	| selectedTests |
	population ifEmpty: [ ^ population ].
	selectedTests := OrderedCollection new.
	self selectors do: [ :sel | 
		selectedTests addAll:
			(sel doSelect: population selected: aPopulationAll) ].
	^ selectedTests collect: [ :obj | 
		  SATestMethod
			  with: (self astHelper cleanUp: obj testMethod)
			  class: obj testClass
			  targets: obj testTargets ]
]

{ #category : #accessing }
SAMainLoop >> selectors [
	self flag: #TODO. "change the name. selector is used to the name of methods. selection is better"
	^ config selectors
]

{ #category : #'as yet unclassified' }
SAMainLoop >> strip [
	population
		do: [ :tcase | tcase strip ]
		displayingProgress: 'Strip Test Methods'
]

{ #category : #accessing }
SAMainLoop >> targetClasses [
	^ targetClasses
]

{ #category : #accessing }
SAMainLoop >> targetClasses: arrayOfTargetClasses [
	targetClasses := arrayOfTargetClasses
]

{ #category : #accessing }
SAMainLoop >> testClass [
	^ testClass
]

{ #category : #accessing }
SAMainLoop >> testClass: atestClass [
	testClass := atestClass.
	self discardFailingTests 
]
