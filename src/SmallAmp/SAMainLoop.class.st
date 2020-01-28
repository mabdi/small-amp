Class {
	#name : #SAMainLoop,
	#superclass : #Object,
	#instVars : [
		'testClass',
		'targetClasses',
		'population',
		'config',
		'finalResult',
		'resultPeople'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #'instance creation' }
SAMainLoop class >> with: aConfig for: aTestClass targets: targetClasses [
	^ self new
		  with: aConfig for: aTestClass targets: targetClasses;	
		  yourself
]

{ #category : #adding }
SAMainLoop >> addPopulationToResult [
	population do: [ :item |  resultPeople add: item clone ]
]

{ #category : #actions }
SAMainLoop >> amplify [
	self methodProfiling.
	self initialAssertionAmplify.
	config lite
		ifFalse: [ (1 to: config iterations)
				do: [ :gen | 
					self strip.
					self inputAmplification.
					self assertionAmplification.
					self selection.
					self cleanUpAndAddToResult ]
				displayingProgress: 'Main loop' , ' (' , config iterations asString , ')' ].
	^ self makeResult
]

{ #category : #private }
SAMainLoop >> assertionAmplification [
	population
		do: [ :tcase | 
			self assertionAmplifiers do: [ :amplifier | 
				tcase assertionAmplifyBy: (amplifier ) ] ]
		displayingProgress: 'Assertion Amplification',' (', population size asString , ')'
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

{ #category : #cleanup }
SAMainLoop >> cleanUpAndAddToResult [
	population := population collect: [ :obj | obj cleanedUpCopy ].
	self addPopulationToResult 
]

{ #category : #actions }
SAMainLoop >> discardFailingTests [
	| result testMethods |
	result := testClass suite run.
	testMethods := result passed collect: [ :passed | 
		               (testClass methodNamed: passed selector) sourceCode ].
	finalResult failedSelectorInOriginal: result failures.
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
		displayingProgress: 'Assertion Amplification',' (', aPopulation size asString , ')'.
	resultPeople addAll: aPopulation 
]

{ #category : #initialization }
SAMainLoop >> initialize [
	finalResult := SAResultItem new.
	resultPeople := OrderedCollection new.
]

{ #category : #private }
SAMainLoop >> inputAmplification [
	| newcodes |
	newcodes := OrderedCollection new.
	population
		do: [ :tcase | 
			self inputAmplifiers do: [ :amplifier | 
				newcodes addAll: (tcase inputAmplifyBy: amplifier) ] ]
		displayingProgress: 'Input Amplification',' (', population size asString , ')'.
	population addAll: newcodes
]

{ #category : #accessing }
SAMainLoop >> inputAmplifiers [
	^ config inputAmplifiers collect: [ :amplifier | 
		  amplifier initializeWith: config ]
]

{ #category : #private }
SAMainLoop >> makeResult [
	| reducers generatedClass |
	generatedClass := self astHelper
		buildTestClassWith: (resultPeople collect: [ :tcase | tcase testMethod ])
		using: testClass.
	reducers := self reducerFor: generatedClass.
	finalResult mutalkRunOriginal.
	finalResult
		reducedVersions: (reducers collect: [ :reducer | reducer ignoredTestMethods: finalResult failedSelectorInOriginal. reducer makeReducedResult ]).
	^ finalResult
]

{ #category : #private }
SAMainLoop >> methodProfiling [
	config profiler
		ifNotNil: [ config profiler profileClasses: targetClasses byRunning: testClass ]
]

{ #category : #private }
SAMainLoop >> reducerFor: aClass [
	^ config oracleReducions
		collect: [ :reducer | 
			(reducer initializeWith: config)
				with: aClass
				from: testClass
				target: targetClasses ]
]

{ #category : #actions }
SAMainLoop >> selection [ 
	| selectedTests |
	population ifEmpty: [ ^ self ].
	selectedTests := OrderedCollection new.
	self selections do: [ :sel | 
		selectedTests addAll:
			(sel select: population alreadySelected: resultPeople) ].
	population := selectedTests
]

{ #category : #accessing }
SAMainLoop >> selections [
	^ config selections collect: [ :selection | 
		  selection initializeWith: config ]
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
	finalResult targetClasses: targetClasses.
	finalResult testClass: testClass.
	
	self discardFailingTests
]
