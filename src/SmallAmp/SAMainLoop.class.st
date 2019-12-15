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
	#category : #'SmallAmp-Core'
}

{ #category : #'instance creation' }
SAMainLoop class >> with: aConfig for: aTestClass targets: targetClasses [
	^ self new
		  with: aConfig for: aTestClass targets: targetClasses;	
		  yourself
]

{ #category : #actions }
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
				self cleanUp .
				resultPeople addAll: population ]
			displayingProgress: 'Main loop' ].
	^ self makeResult: resultPeople
]

{ #category : #private }
SAMainLoop >> assertionAmplification [
	population
		do: [ :tcase | 
			self assertionAmplifiers do: [ :amplifier | 
				tcase assertionAmplifyBy: (amplifier ) ] ]
		displayingProgress: 'Assertion Amplification'
]

{ #category : #asserting }
SAMainLoop >> assertionAmplifiers [
	^ config assertionAmplifiers collect: [ :amplifier | amplifier initializeWith: config ]
]

{ #category : #accessing }
SAMainLoop >> astHelper [
	^ SAASTHelper new
]

{ #category : #cleanup }
SAMainLoop >> cleanUp [
	population := population collect: [ :obj | obj cleanedUpCopy  ]
]

{ #category : #actions }
SAMainLoop >> discardFailingTests [
	| result testMethods |
	result := testClass suite run.
	testMethods := result passed collect: [ :passed | 
		               (testClass methodNamed: passed selector) sourceCode ].
	finalResult addFailedSelectorInOriginal: result failures.
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
	^ config inputAmplifiers collect: [ :amplifier | 
		  amplifier initializeWith: config ]
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
	self selections do: [ :sel | 
		selectedTests addAll:
			(sel select: population alreadySelected: aSelectedPopulation) ].
	population := selectedTests
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
