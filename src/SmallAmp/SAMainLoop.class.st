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

{ #category : #'as yet unclassified' }
SAMainLoop >> allOpenedWindows [
	^  SystemWindow allInstances, GLMSystemWindow allInstances.
]

{ #category : #actions }
SAMainLoop >> amplify [
	self initialSteps.
	(1 to: config iterations)
		do: [ :gen | 
			uncovered ifNotEmpty: 
			[self normalize.
			self inputAmplification.
			self methodReduction.
			self assertionAmplification.
			self selection.
			self cleanUpAndAddToResult] ]
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
	| allWindows |
	finalResult logs
		recoredTag: #assertionAmplification
		toRun: [ allWindows := self allOpenedWindows.	"this operation is an expensive op. time consuming. I moved from a-ampilier to here."
							population
				do: [ :tcase | 
					self assertionAmplifiers
						do: [ :amplifier | 
							tcase assertionAmplifyBy: amplifier ] ]
				displayingProgress: 'Assertion Amplification' , ' (' , population size asString , ')'.
							self closeAllWindowsBut: allWindows.
			population := population
				reject: [ :tcase | tcase testMethod isNil ] ]
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

{ #category : #'as yet unclassified' }
SAMainLoop >> closeAllWindowsBut: openWindows [
| actualWindows |
	actualWindows := self allOpenedWindows.
	(actualWindows copyWithoutAll: openWindows) do: #delete
]

{ #category : #actions }
SAMainLoop >> discardFailingTests [
	| result testMethods |
	result := [ testClass suite run ]
		valueWithin: config testRunTimeOut milliSeconds
		onTimeout: [ self error: 'Check Me' ].
	testMethods := result expectedPasses
		collect: [ :passed | (passed class lookupSelector: passed selector) sourceCode ].
	finalResult
		failedSelectorInOriginal: (result failures , result expectedDefects) asOrderedCollection.
	population := testMethods
		collect: [ :tcase | 
			(SATestMethod with: tcase class: testClass targets: targetClasses)
				selectorAppend: '_amp';
				yourself ]
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
		ifNotNil: [ config profiler profileClasses: targetClasses byRunning: testClass.
			finalResult runProfile: config profiler ]
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
				target: targetClasses
				uncovered: finalResult originalAnalysis generalResult aliveMutants.
			reducer ignoredTestMethods: finalResult failedSelectorInOriginal.
			finalResult amplifiedClass: reducer makeReducedResult.
			finalResult mutalkRunMutated ]
]

{ #category : #'as yet unclassified' }
SAMainLoop >> prettifying [
	| prettifier |
	finalResult logs
		recoredTag: #prettifying
		toRun: [ prettifier := config prettifier initializeWith: config.
			prettifier prettify: finalResult amplifiedClass ]
]

{ #category : #actions }
SAMainLoop >> regenerateMethod: aMethodName [
	| method |
	method := testClass allTestSelectors
		detect: [ :m | aMethodName beginsWith: m ]
		ifNone: [ ^ nil ].
	method := (SATestMethod
		with: (testClass methodNamed: method) sourceCode
		class: testClass
		targets: targetClasses)
		selectorAppend: '_amp';
		yourself.
	self methodProfiling.
	1 to: config iterations do: [ :gen | 
		| newcodes |
		method strip.
		method normalize.
		newcodes := self inputAmplifiers
			flatCollect: [ :amplifier | method inputAmplifyBy: amplifier ].
		newcodes
			detect: [ :m | m selector = aMethodName ]
			ifFound: [ :m | ^ m testMethod ]
			ifNone: [  newcodes
					detect: [ :m | aMethodName beginsWith: m selector , '_' ] ifFound: [:m | method := m] ifNone: [ ^ nil ] ] ]
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
	| simplifier |
	finalResult logs
		recoredTag: #simplification
		toRun: [ simplifier := config simplifier initializeWith: config.
			simplifier simplify: finalResult amplifiedClass ]
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
