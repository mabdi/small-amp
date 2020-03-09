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
		'assertionAmplifiers',
		'methodReductions'
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
	resultPeople
		addAll:
			(population
				collect: [ :item | 
					| c |
					c := item clone.
					c signAsSmallAmp.
					c ])
]

{ #category : #actions }
SAMainLoop >> amplify [
	self initialSteps.
	(1 to: config iterations)
		do: [ :gen | 
			self normalize.
			self inputAmplification.
			self methodReduction.
			self assertionAmplification.
			self selection.
			self cleanUpAndAddToResult ]
		displayingProgress: 'Main loop' , ' (' , config iterations asString , ')'.
	self oracleReduction.
	self simplification.
	self prettifying.
	^ finalResult
]

{ #category : #actions }
SAMainLoop >> amplifyLite [
	self initialSteps.
	self liteAmplification.
	self oracleReduction.
	^ finalResult
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
	result := [ testClass suite run ]
		valueWithin: config testRunTimeOut milliSeconds
		onTimeout: [ self error: 'Check Me' ].
	testMethods := result expectedPasses
		collect: [ :passed | (testClass lookupSelector: passed selector) sourceCode ].
	finalResult
		failedSelectorInOriginal: result failures , result expectedDefects.
	population := testMethods
		collect:
			[ :tcase | SATestMethod with: tcase class: testClass targets: targetClasses ]
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
SAMainLoop >> liteAmplification [
	| aPopulation old_Pop |
	finalResult logs
		recoredTag: #liteAmplification
		toRun: [ 
			aPopulation := population
				collect: [ :tcase | tcase renamedCopy: '_amp' ].
			aPopulation do: [ :tcase | tcase strip ].
			aPopulation
				do: [ :tcase | 
					self assertionAmplifiers
						do: [ :amplifier | tcase assertionAmplifyBy: amplifier ] ]
				displayingProgress: 'Assertion Amplification' , ' (' , aPopulation size asString , ')'.
			old_Pop := population.
			population := aPopulation reject: [ :x | x testMethod isNil ].
			self selection.
			self cleanUpAndAddToResult.
			"population addAll: old_Pop ???"
			population := old_Pop ]
]

{ #category : #private }
SAMainLoop >> methodProfiling [
	config profiler
		ifNotNil: [ config profiler profileClasses: targetClasses byRunning: testClass ].
	
]

{ #category : #accessing }
SAMainLoop >> methodReduction [
	| p size |
	size := self methodReductions size asString.
	finalResult logs
		recoredTag: #methodReduction
		toRun: [ p := population.
			self methodReductions
				do: [ :reducer | 
					
					reducer uncovered: uncovered.
					p := reducer reduceMethods: p ]
				displayingProgress: 'Method Reduction' , ' (' , size , ')'.
			population := p ]
]

{ #category : #accessing }
SAMainLoop >> methodReductions [
	methodReductions
		ifNil: [ methodReductions := config methodReductions
				collect: [ :reducer | reducer initializeWith: config ] ].
			^ methodReductions
]

{ #category : #'as yet unclassified' }
SAMainLoop >> normalize [
	finalResult logs
		recoredTag: #strip
		toRun: [ population
				do: [ :tcase | 
					tcase strip.
					tcase normalize ]
				displayingProgress: 'Strip Test Methods' ]
]

{ #category : #private }
SAMainLoop >> oracleReduction [
	| reducer generatedClass |
	finalResult logs
		recoredTag: #oracleReduction
		toRun: [ generatedClass := self astHelper
				buildTestClassWith: (resultPeople collect: [ :tcase | tcase testMethod ])
				using: testClass.
			reducer := (config oracleReducion initializeWith: config)
				with: generatedClass
				from: testClass
				target: targetClasses.
			reducer ignoredTestMethods: finalResult failedSelectorInOriginal.
			finalResult reducedVersion: reducer makeReducedResult ].
	^ finalResult
]

{ #category : #'as yet unclassified' }
SAMainLoop >> prettifying [
	| a |
	self flag: #TODO.	"pack statements"
	self flag: #TODO.	"rename variables"
	
]

{ #category : #private }
SAMainLoop >> recordLog: aTag [
	finalResult logs timeTickFor: aTag
]

{ #category : #private }
SAMainLoop >> reducerFor: aClass [
	^ (config oracleReducion initializeWith: config)
				with: aClass
				from: testClass
				target: targetClasses
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
SAMainLoop >> simplification [
	self flag: #TODO	
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
