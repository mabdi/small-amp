Class {
	#name : #SAMainLoop,
	#superclass : #Object,
	#instVars : [
		'testClass',
		'targetClasses',
		'population',
		'config',
		'finalResult'
	],
	#category : #'Amplification-Core'
}

{ #category : #'instance creation' }
SAMainLoop class >> with: aConfig for: aTestClass targets: targetClasses [
	^ self new
		  with: aConfig for: aTestClass targets: targetClasses;	
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
			self assertionAmplifiers do: [ :amplifier | 
				tcase assertionAmplifyBy: amplifier ] ]
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

{ #category : #actions }
SAMainLoop >> discardFailingTests [
	| result testMethods |
	result := testClass suite run.
	testMethods := result passed collect: [ :passed | 
		               (testClass methodNamed: passed selector) sourceCode ].
	finalResult addFailedSelectorInOriginal: result failed.
	population := testMethods collect: [ :tcase | 
		              SATestMethod
			              with: tcase
			              class: testClass
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
			tcase cleanUp ]
		displayingProgress: 'Assertion Amplification'.
	^ aPopulation
]

{ #category : #private }
SAMainLoop >> inputAmplification [
	| newcodes |
	newcodes := OrderedCollection new.
	population
		do: [ :tcase | 
			self inputAmplifiers do: [ :amplifier | 
				newcodes addAll: (tcase inputAmplifyBy: amplifier) ] ]
		displayingProgress: 'Input Amplification'.
	population addAll: newcodes
]

{ #category : #accessing }
SAMainLoop >> inputAmplifiers [
	^ config inputAmplifiers
]

{ #category : #private }
SAMainLoop >> makeResult: resultPeople [
	self flag: #TODO.
	finalResult addNewTestClass: (self astHelper
		                buildTestClassWith:
		                (resultPeople collect: [ :tcase | tcase testMethod ])
		                using: testClass).
	^ SAResultItem new
]

{ #category : #private }
SAMainLoop >> methodProfiling [
	targetClasses do: [ :anObjectUnderTest | 
		SAMethodProfiler classifyClass: anObjectUnderTest ]
]

{ #category : #actions }
SAMainLoop >> selectionAlreadySelected: aSelectedPopulation [
	| selectedTests |
	population ifEmpty: [ ^ self ].
	selectedTests := OrderedCollection new.
	self selectors do: [ :sel | 
		selectedTests addAll:
			(sel doSelect: population selected: aSelectedPopulation) ].
	population := selectedTests collect: [ :obj | 
		SATestMethod
			with: (self astHelper cleanUp: obj testMethod)
			class: obj testClass
			targets: obj testTargets ]
]

{ #category : #accessing }
SAMainLoop >> selections [
	^ config selections
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
SAMainLoop >> testClass [
	^ testClass
]

{ #category : #'instance creation' }
SAMainLoop >> with: aConfig for: aTestClass targets: listofTargetClasses [
	self initialize.
	config := aConfig.
	targetClasses := listofTargetClasses.
	testClass := aTestClass.
	finalResult := SAResultItem new.
	self discardFailingTests
]
