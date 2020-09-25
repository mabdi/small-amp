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
		'testRunTimeoutMillis',
		'selection',
		'assertAmplificationClassCache',
		'instantiationExtractor'
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
	^ self subclassResponsibility  
]

{ #category : #private }
SAMainLoop >> assertionAmplification [
	population := self assertionAmplificationFor: population
]

{ #category : #private }
SAMainLoop >> assertionAmplificationFor: aList [
	| allWindows |
	finalResult logs
		recoredTag: #assertionAmplification
		toRun:
			[ allWindows := self allOpenedWindows.	"this operation is an expensive op. time consuming. I moved from a-ampilier to here."
			aList
				do: [ :tcase | 
					self assertionAmplifiers
						do: [ :amplifier | 
							" dirty  but necessary. recreating a temp class is very time cosuming "
							assertAmplificationClassCache
								ifNotNil: [ amplifier generatedClass: assertAmplificationClassCache ].
							amplifier testRunTimeoutMillis: testRunTimeoutMillis.
							tcase assertionAmplifyBy: amplifier.
							assertAmplificationClassCache := amplifier generatedClass ] ]
				displayingProgress: 'Assertion Amplification' , ' (' , aList size asString , ')'.
			self closeAllWindowsBut: allWindows.
			^ aList
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
	population := testMethods
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
	^ self inputAmplificationFrom: population
]

{ #category : #private }
SAMainLoop >> inputAmplificationFrom: pop [
	| newcodes |
	finalResult logs
		recoredTag: #inputAmplification
		toRun: [ newcodes := OrderedCollection new.
			pop
				do: [ :tcase | 
					self inputAmplifiers
						do: [ :amplifier | newcodes addAll: (tcase inputAmplifyBy: amplifier) ] ]
				displayingProgress: 'Input Amplification' , ' (' , pop size asString , ')'.
			population addAll: newcodes ]
]

{ #category : #accessing }
SAMainLoop >> inputAmplifiers [
	^ config inputAmplifiers
		collect: [ :amplifier | amplifier key initializeWith: config ]
]

{ #category : #private }
SAMainLoop >> inputTransplantation [
	^ self inputTransplantationFrom: population 
]

{ #category : #private }
SAMainLoop >> inputTransplantationFrom: aPopulation [
	| newcodes transplantor |
	finalResult logs
		recoredTag: #inputTransplantation
		toRun: [ newcodes := OrderedCollection new.
			transplantor := SAInstantiationTransplanter initializeWith: config.
			transplantor instantiationPatterns: instantiationExtractor patterns.
			aPopulation
				do: [ :tcase | newcodes addAll: (tcase inputAmplifyBy: transplantor) ]
				displayingProgress: 'Input inputTransplantation' , ' (' , aPopulation size asString , ')'.
			population addAll: newcodes ]
]

{ #category : #private }
SAMainLoop >> methodProfiling [
	config profiler
		ifNotNil: [ config profiler reset.
			self flag: #TODO.	"why wee need cache profiles in config?"
			config profiler profileClasses: targetClasses byRunning: testClass.
			finalResult runProfile: config profiler ].
	instantiationExtractor := SAObjectInstantiationExtractor new.
	instantiationExtractor testClass: testClass.
	instantiationExtractor run
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
	population := self selectionFrom: population. 
	
]

{ #category : #actions }
SAMainLoop >> selectionFrom: aList [
	| selectedTests |
	finalResult logs
		recoredTag: #selection
		toRun: [ aList ifEmpty: [ ^ {  } ].
			selectedTests := OrderedCollection new.
			selectedTests addAll: (selection select: aList).
			^ selectedTests ]
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
