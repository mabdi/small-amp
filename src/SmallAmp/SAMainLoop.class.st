Class {
	#name : #SAMainLoop,
	#superclass : #Object,
	#instVars : [
		'testClass',
		'targetClasses',
		'population',
		'config',
		'finalResult',
		'resultPeople',
		'uncovered',
		'inputAmplifiers',
		'assertionAmplifiers'
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
	self initialSteps.
	"self initialAssertionAmplify."
	config lite
		ifFalse: [ (1 to: config iterations)
				do: [ :gen | 
					
					self strip.
					self inputAmplification.
					self methodReduction.
					self assertionAmplification.
					self selection.
					self cleanUpAndAddToResult ]
				displayingProgress: 'Main loop' , ' (' , config iterations asString , ')' ].
	^ self makeResult
]

{ #category : #private }
SAMainLoop >> assertionAmplification [
	finalResult logs
		recoredTag: #assertionAmplification
		toRun: [population
		do: [ :tcase | 
			self assertionAmplifiers
				do: [ :amplifier | tcase assertionAmplifyBy: amplifier ] ]
		displayingProgress: 'Assertion Amplification' , ' (' , population size asString , ')'.
	population := population reject: [ :tcase | tcase testMethod isNil ].]
	
]

{ #category : #asserting }
SAMainLoop >> assertionAmplifiers [
	^ assertionAmplifiers
		ifNil: [ assertionAmplifiers := config assertionAmplifiers
				collect: [ :amplifier | amplifier initializeWith: config ] ]
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
	finalResult logs
		recoredTag: #cleanUpAndAddToResult
		toRun: [population := population collect: [ :obj | obj cleanedUpCopy ].
	self addPopulationToResult.]
	
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
	self recordLog: #initialAssertionAmplify.
	aPopulation := population
		collect: [ :tcase | tcase renamedCopy: '_amp' ].
	aPopulation do: [ :tcase | tcase strip ].
	aPopulation
		do: [ :tcase | 
			self assertionAmplifiers
				do: [ :amplifier | tcase assertionAmplifyBy: amplifier ] ]
		displayingProgress: 'Assertion Amplification' , ' (' , aPopulation size asString , ')'.
	aPopulation := aPopulation reject: [ :x | x testMethod isNil ].
	aPopulation do: [ :tcase | tcase cleanUp ].
	resultPeople addAll: aPopulation.
	self recordLog: #initialAssertionAmplify
]

{ #category : #'as yet unclassified' }
SAMainLoop >> initialSteps [
finalResult logs
		recoredTag: #initialSteps
		toRun:
	[self discardFailingTests.
	finalResult mutalkRunOriginal.
	uncovered := finalResult originalAnalysis generalResult aliveMutants.
	self methodProfiling.]
]

{ #category : #initialization }
SAMainLoop >> initialize [
	finalResult := SAResultItem new.
	resultPeople := OrderedCollection new.
]

{ #category : #private }
SAMainLoop >> inputAmplification [
	| newcodes |
	finalResult logs
		recoredTag: #inputAmplification
		toRun: 
	[newcodes := OrderedCollection new.
	population
		do: [ :tcase | 
			self inputAmplifiers
				do: [ :amplifier | newcodes addAll: (tcase inputAmplifyBy: amplifier) ] ]
		displayingProgress: 'Input Amplification' , ' (' , population size asString , ')'.
	population addAll: newcodes]
]

{ #category : #accessing }
SAMainLoop >> inputAmplifiers [
	^  config inputAmplifiers
				collect: [ :amplifier | amplifier initializeWith: config ] 
]

{ #category : #private }
SAMainLoop >> makeResult [
	| reducers generatedClass |
	finalResult logs
		recoredTag: #makeResult
		toRun: [ generatedClass := self astHelper
				buildTestClassWith: (resultPeople collect: [ :tcase | tcase testMethod ])
				using: testClass.
			reducers := self reducerFor: generatedClass.
			finalResult
				reducedVersions:
					(reducers asOrderedCollection
						collect: [ :reducer | 
							reducer ignoredTestMethods: finalResult failedSelectorInOriginal.
							reducer makeReducedResult ]
						displayingProgress: 'Reducing oracles (' , reducers size asString , ')') ].
	^ finalResult
]

{ #category : #private }
SAMainLoop >> methodProfiling [
	config profiler
		ifNotNil: [ config profiler profileClasses: targetClasses byRunning: testClass ].
	
]

{ #category : #accessing }
SAMainLoop >> methodReduction [
	| p |
	finalResult logs
		recoredTag: #methodReduction
		toRun: [ p := population.
			self methodReductions
				do: [ :reducer | 
					reducer uncovered: uncovered.
					p := reducer reduceMethods: p ]
				displayingProgress: 'Method Reduction' , ' (' , self methodReductions size asString , ')'.
			population := p ]
]

{ #category : #accessing }
SAMainLoop >> methodReductions [
	^ config methodReductions
				collect: [ :reducer | reducer initializeWith: config ] 
]

{ #category : #private }
SAMainLoop >> recordLog: aTag [
	finalResult logs timeTickFor: aTag
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
	finalResult logs
		recoredTag: #selection
		toRun:
	[population ifEmpty: [ ^ self ].
	selectedTests := OrderedCollection new.
	self selections
		do: [ :sel | 
			selectedTests addAll: (sel select: population uncovered: uncovered).
			uncovered := sel uncovered ]
		displayingProgress: 'Selection' , ' (' , self selections size asString , ')'.
	population := selectedTests].
	
]

{ #category : #accessing }
SAMainLoop >> selections [
	^ config selections collect: [ :selection | 
		  selection initializeWith: config ]
]

{ #category : #'as yet unclassified' }
SAMainLoop >> strip [
	finalResult logs
		recoredTag: #strip
		toRun: [population
		do: [ :tcase | tcase strip ]
		displayingProgress: 'Strip Test Methods'.
	]
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
	
]
