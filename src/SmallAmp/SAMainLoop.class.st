Class {
	#name : #SAMainLoop,
	#superclass : #Object,
	#instVars : [
		'testClass',
		'targetClasses',
		'elites',
		'population',
		'config',
		'finalResult',
		'resultPeople',
		'testRunTimeoutMillis',
		'selection',
		'assertAmplificationClassCache'
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
	| newElites |
	newElites := population
		collect: [ :item | 
			| c |
			c := item clone.
			c signAsSmallAmp.
			c ].
	resultPeople addAll: newElites.
	elites addAll: newElites
]

{ #category : #'as yet unclassified' }
SAMainLoop >> allOpenedWindows [
	^  SystemWindow allInstances, GLMSystemWindow allInstances.
]

{ #category : #actions }
SAMainLoop >> amplify [
	| ts_start skip |
	ts_start := DateAndTime now.
	self initialSteps.
	(1 to: config iterations)
		do: [ :gen | 
			Stdio stdout
				nextPutAll: 'New generation started: ';
				nextPutAll: gen asString;
				lf;
				flush.
			skip := selection uncovered isEmpty.
			config timeBudget > 0
				ifTrue: [ (DateAndTime now - ts_start) asSeconds > config timeBudget
						ifTrue: [ skip := true.
							finalResult timeBudgetFinished: true ] ].
			skip
				ifFalse: [ 
					self setupPopulation.
					self normalize.
					self inputAmplification.
					self methodReduction.
					self assertionAmplification.
					self selection.
					self cleanUpAndAddToResult ] ]
		displayingProgress: 'Main loop' , ' (' , config iterations asString , ')'.
	self oracleReduction.
	self simplification.
	self prettifying.
	self finalSteps.
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
		toRun:
			[ allWindows := self allOpenedWindows.	"this operation is an expensive op. time consuming. I moved from a-ampilier to here."
			population
				do: [ :tcase | 
					self assertionAmplifiers
						do: [ :amplifier | 
							" dirty  but necessary. recreating a temp class is very time cosuming "
							assertAmplificationClassCache
								ifNotNil: [ amplifier generatedClass: assertAmplificationClassCache ].
							amplifier testRunTimeoutMillis: testRunTimeoutMillis.
							tcase assertionAmplifyBy: amplifier.
							assertAmplificationClassCache := amplifier generatedClass ] ]
				displayingProgress: 'Assertion Amplification' , ' (' , population size asString , ')'.
			self closeAllWindowsBut: allWindows.
			population := population
				reject: [ :tcase | tcase testMethod isNil ] ]
]

{ #category : #asserting }
SAMainLoop >> assertionAmplifiers [
	^ config assertionAmplifiers
				collect: [ :amplifier | amplifier initializeWith: config]
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
	[ testRunTimeoutMillis := [ result := testClass suite run ] timeToRun
		asMilliSeconds ]
		valueWithin: config testRunTimeOut milliSeconds
		onTimeout: [ self error: 'Original test class timeout' ].
	testRunTimeoutMillis := {1000.
	testRunTimeoutMillis} max.
	testMethods := result expectedPasses
		collect:
			[ :passed | (passed class lookupSelector: passed selector) sourceCode ].
	finalResult
		failedSelectorInOriginal:
			(result failures , result expectedDefects
				collect: [ :failed | failed class lookupSelector: failed selector ])
				asOrderedCollection.
	testMethods ifEmpty: [ SANoGreenTest new signal ].
	elites := testMethods
		collect: [ :tcase | 
			(SATestMethod with: tcase class: testClass targets: targetClasses)
				selectorAppend: '_amp';
				yourself ]
]

{ #category : #actions }
SAMainLoop >> finalSteps [
	self astHelper moveClassToFinal: finalResult amplifiedClass .
	finalResult
		amplifiedAnalysis:
			(selection
				analysisFor: {finalResult amplifiedClass}
				targets: targetClasses
				ignore: finalResult failedSelectorInOriginal)
]

{ #category : #'as yet unclassified' }
SAMainLoop >> initialSteps [
	finalResult logs
		recoredTag: #initialSteps
		toRun: [ self discardFailingTests.
			self setupSelection.
			
			self methodProfiling ]
]

{ #category : #initialization }
SAMainLoop >> initialize [
	finalResult := SAResultItem new.
	resultPeople := OrderedCollection new.
]

{ #category : #private }
SAMainLoop >> inputAmplification [
	| newcodes halfPop |
	finalResult logs
		recoredTag: #inputAmplification
		toRun: [ | popsize |
			popsize := config maxPopPerMethod
				ifNotNil: [ :permethod | permethod * population size min: config maxPop ]
				ifNil: [ config maxPop ].
			halfPop := popsize / 2.
			newcodes := OrderedCollection new.
			population
				do: [ :tcase | 
					self inputAmplifiers
						do: [ :amplifier | newcodes addAll: (tcase inputAmplifyBy: amplifier) ] ]
				displayingProgress: 'Input Amplification' , ' (' , population size asString , ')'.

			"(1 to: config maxPop)
				do: [ :i | 
					| tcase amplifier newInputs |
					tcase := population atRandom.
					amplifier := self inputAmplifiers atRandom.
					newInputs := tcase inputAmplifyBy: amplifier.
					newInputs ifNotEmpty: [ newcodes add: newInputs atRandom ] ]
				displayingProgress: 'Input Amplification' , ' (' , population size asString , ')'."
			newcodes := newcodes shuffle first: (halfPop min: newcodes size).
			(1 to: halfPop)
				do: [ :i | 
					| amplifier tcase newInputs |
					amplifier := self inputAmplifiers atRandom.
					tcase := newcodes atRandom.
					newInputs := tcase inputAmplifyBy: amplifier.
					newInputs ifNotEmpty: [ newcodes add: newInputs atRandom ] ]
				displayingProgress: 'Input Amplification (x2) (' , halfPop asString , ')'.
			population addAll: newcodes ]
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
		toRun: [ aPopulation := population
				collect: [ :tcase | tcase renamedCopy: '_amp' ].
			aPopulation do: [ :tcase | tcase strip ].
			aPopulation
				do: [ :tcase | 
					self assertionAmplifiers
						do: [ :amplifier | amplifier testRunTimeoutMillis: testRunTimeoutMillis . tcase assertionAmplifyBy: amplifier ] ]
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
		ifNotNil: [ config profiler reset.
			self flag: #TODO "why wee need cache profiles in config?".
			config profiler profileClasses: targetClasses byRunning: testClass.
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
					reducer
						uncovered: selection uncovered;
						testRunTimeoutMillis: testRunTimeoutMillis.
					p := reducer reduceMethods: p ]
				displayingProgress: 'Method Reduction' , ' (' , size , ')'.
			population := p ]
]

{ #category : #accessing }
SAMainLoop >> methodReductions [
	^ config methodReductions
				collect: [ :reducer | reducer initializeWith: config ]
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
				uncovered: finalResult notCoveredInOriginal.
			reducer ignoredTestMethods: finalResult failedSelectorInOriginal.
			finalResult amplifiedClass: reducer makeReducedResult.
			 ]
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
		with: (testClass lookupSelector: method) sourceCode
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
			ifNone: [ newcodes
					detect: [ :m | aMethodName beginsWith: m selector , '_' ]
					ifFound: [ :m | method := m ]
					ifNone: [ ^ nil ] ] ]
]

{ #category : #actions }
SAMainLoop >> selection [
	| selectedTests |
	finalResult logs
		recoredTag: #selection
		toRun: [ population ifEmpty: [ ^ self ].
			selectedTests := OrderedCollection new.
			
				 
					selectedTests addAll: (selection select: population).
			population := selectedTests ]
]

{ #category : #actions }
SAMainLoop >> setupPopulation [
	population := elites
		collect: [ :item | 
			| c |
			c := item clone.
			c ]
]

{ #category : #'as yet unclassified' }
SAMainLoop >> setupSelection [
	selection := config selection initializeWith: config.
	finalResult
		originalAnalysis:
			(selection
				initialAnalysisFor: {testClass}
				targets: targetClasses
				ignore: finalResult failedSelectorInOriginal).
	selection uncovered ifEmpty: [ SANoUncovered new signal  ]
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
