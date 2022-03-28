Class {
	#name : #SAMainLoopDspot,
	#superclass : #SAMainLoop,
	#instVars : [
		'theTS',
		'resultPeople',
		'testRunTimeoutMillis',
		'selection',
		'assertAmplifier',
		'instantiationExtractor',
		'variableTypes',
		'nextTest',
		'numberOfAmplified'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SAMainLoopDspot >> amplify [

	^ config ranking ifTrue: [ self amplifyRanking  ] ifFalse: [ self amplifyNotRanking  ]
]

{ #category : #'as yet unclassified' }
SAMainLoopDspot >> amplifyATestMethod: aTestMethod initialAssertionAmplification: doInitialAssertionAmplification [

	| theATS theV theU |
	numberOfAmplified := numberOfAmplified + 1.
	SmallAmp <~ ('{1}, score: {2}' format:
		 { aTestMethod selector. aTestMethod score }).
	self variableTypesProfile: aTestMethod.
	theATS := OrderedCollection new.
	theV := OrderedCollection with: aTestMethod.
	theV do: #strip.
	doInitialAssertionAmplification ifTrue: [ 
		theU := self assertionAmplificationFor: (theV collect: #clone).
		theU := self selectionFrom: theU.
		theATS addAll: theU ].
	(1 to: config iterations)
		do: [ :gen | 
			SmallAmp <~ ('iteration: ' , gen asString).
			theV := self inputAmplificationFrom: theV.
			theU := self assertionAmplificationFor: (theV collect: #clone).
			theU := self selectionFrom: theU.
			theATS addAll: theU ]
		displayingProgress:
		'Main loop' , ' (' , config iterations asString , ')'.
	theATS := theATS collect: [ :item | 
		          | c |
		          c := item cleanedUpCopy.
		          c signAsSmallAmp.
		          c ].
	resultPeople addAll: theATS
]

{ #category : #'as yet unclassified' }
SAMainLoopDspot >> amplifyNotRanking [

	theTS := self initTs.
	self setupSelection.
	self methodProfiling.
	theTS
		do: [ :aTestMethod | 
			self careTimeBudget 
				ifTrue: [ self amplifyATestMethod: aTestMethod initialAssertionAmplification: true ]
				ifFalse: [ SmallAmp <~ ('No time budget. Skipping: ', aTestMethod selector) ]
			 ] 
		displayingProgress: [ :aTestMethod | 'Amplifying: ' , aTestMethod selector ].
	self finalSteps.
	^ finalResult
]

{ #category : #'as yet unclassified' }
SAMainLoopDspot >> amplifyRanking [

	theTS := self initTs.
	self setupSelection.
	self methodProfiling.
	self scoreTestsWithUncovered: selection uncovered.
	self doInitialAssertionAmplification.
	[ nextTest isNotNil and: [ self careTimeBudget ] ] whileTrue: [ 
		self
			amplifyATestMethod: nextTest
			initialAssertionAmplification: false.
		nextTest isAmplified: true.
		self scoreTestsWithUncovered: selection uncovered ].
	self finalSteps.
	^ finalResult
]

{ #category : #private }
SAMainLoopDspot >> assertionAmplificationFor: aList [
	self careTimeBudget ifFalse: [ ^ {  } ].
	aList
		do: [ :tcase | 
			self careTimeBudget 
				ifTrue: [ tcase assertionAmplifyBy: assertAmplifier. ] 
				ifFalse: [ tcase testMethod: nil  ].
			 ]
		displayingProgress: 'Assertion Amplification' , ' (' , aList size asString , ')'.
	^ aList reject: [ :tcase | tcase testMethod isNil ]
]

{ #category : #'as yet unclassified' }
SAMainLoopDspot >> doInitialAssertionAmplification [
	| theV theU theATS |
	theATS := OrderedCollection new.
	theV := OrderedCollection withAll: self rankedPopulation.
	theV do: #strip.
	theU := self assertionAmplificationFor: (theV collect: #clone).
	theU := self selectionFrom: theU.
	theATS addAll: theU.
	theATS := theATS collect: [ :item | 
		          | c |
		          c := item cleanedUpCopy.
		          c signAsSmallAmp.
		          c ].
	resultPeople addAll: theATS.
]

{ #category : #actions }
SAMainLoopDspot >> finalSteps [

	| generatedClass readable testClasses |
	SmallAmp <~ 'final steps'.
	generatedClass := SAGenericMethods new
		                  buildTestClassAndLogWith:
		                  (resultPeople collect: #testMethod)
		                  using: testClass smallAmpOriginalTestCase.
	self logAmplifiedMethodsInfo.
	finalResult amplifiedClass: generatedClass.
	finalResult amplifiedClassInitial: generatedClass.
	readable := self makeReadable.
	finalResult amplifiedClass: readable.
	finalResult numberOfProcessedMethods: numberOfAmplified.
	SAGenericMethods new moveClassToFinal: readable.
	resultPeople ifNotEmpty: [ 
		testClasses := OrderedCollection with:
			               finalResult amplifiedClassInitial.
		testClass smallAmpOriginalTestCase = testClass ifFalse: [ 
			testClasses add: testClass smallAmpOriginalTestCase ].

		finalResult amplifiedAnalysis: (selection
				 analysisFor: testClasses
				 targets: targetClasses
				 ignore: finalResult failedSelectorInOriginal) ]
]

{ #category : #actions }
SAMainLoopDspot >> initTs [

	| result testMethods |
	[ 
	testRunTimeoutMillis := [ result := testClass suite run ] timeToRun
		                        asMilliSeconds ]
		valueWithin: config testRunTimeOut milliSeconds
		onTimeout: [ self error: 'Original test class timeout' ].
	finalResult testClassTimeToRunInMillis: testRunTimeoutMillis.
	testRunTimeoutMillis := { 
		                        1000.
		                        testRunTimeoutMillis } max.
	assertAmplifier := config assertionAmplifier initializeWith: config.

	assertAmplifier testRunTimeoutMillis: testRunTimeoutMillis.
	testMethods := result expectedPasses collect: [ :passed | 
		               (passed class lookupSelector: passed selector)
			               sourceCode ].
	finalResult failedSelectorInOriginal:
		(result failures , result expectedDefects collect: [ :failed | 
			 failed class lookupSelector: failed selector ])
			asOrderedCollection.
	testMethods ifEmpty: [ SANoGreenTest new signal ].
	finalResult numberOfOriginalTestMethods: testMethods size.
	^ testMethods collect: [ :tcase | 
		  (SATestMethod with: tcase class: testClass targets: targetClasses)
			  selectorAppend: '_amp';
			  yourself ]
]

{ #category : #initialization }
SAMainLoopDspot >> initialize [
	super initialize.
	resultPeople := OrderedCollection new.
	numberOfAmplified := 0
]

{ #category : #private }
SAMainLoopDspot >> inputAmplificationFrom: pop [

	| applyTransformation newcodes tmp amps testsSizeHalf |
	self careTimeBudget ifFalse: [ ^ {  } ].
	testsSizeHalf := (0.5 * config maxPop) asInteger.
	amps := self inputAmplifiers.
	newcodes := OrderedCollection new.
	applyTransformation := [ :amplifier :tcase | 
	                       self careTimeBudget ifTrue: [ 
		                       amplifier isTypeSensitive ifTrue: [ 
			                       amplifier variableTypes: variableTypes ].
		                       amplifier isTransplantation ifTrue: [ 
			                       amplifier instantiationPatterns:
				                       instantiationExtractor patterns ].
		                       newcodes addAll:
			                       (tcase inputAmplifyBy: amplifier) ] ].
	tmp := (pop collect: #clone) do: [ :tcase | 
		       tcase strip.
		       tcase normalize.
		tcase strip ].
	amps
		do: [ :amp | 
			| tmp2 |
			tmp2 := (testsSizeHalf / amps size) ceiling.
			(tmp shuffle takeFirst: (tmp2 min: pop size)) do: [ :tcase | 
				applyTransformation value: amp value: tcase ] ]
		displayingProgress:
		'Input Amplification half 1' , ' (' , amps size asString , ')'.
	tmp := pop size > testsSizeHalf
		       ifTrue: [ tmp shuffle takeFirst: testsSizeHalf ]
		       ifFalse: [ tmp ].
	tmp
		do: [ :tcase | 
			| tmp2 |
			tmp2 := (testsSizeHalf + 1 / tmp size) ceiling.
			(amps shuffle takeFirst: (tmp2 min: amps size)) do: [ :amp | 
				applyTransformation value: amp value: tcase ] ]
		displayingProgress:
		'Input Amplification half 2' , ' (' , tmp size asString , ')'.
	^ newcodes shuffle takeFirst: testsSizeHalf * 2
]

{ #category : #accessing }
SAMainLoopDspot >> inputAmplifiers [
	^ config inputAmplifiers
		collect: [ :amplifier | amplifier key initializeWith: config ]
]

{ #category : #'as yet unclassified' }
SAMainLoopDspot >> logAmplifiedMethodsInfo [

	| info |
	info := resultPeople collect: [ :mmodel | 
		        { 
			        (#selector_generated -> mmodel selector).
			        (#from -> mmodel getOriginalTestFullName).
			        (#transformations -> mmodel getTransformationsList asArray).
			        (#newCoverage
			         ->
			         (selection class getNewCoveredFor: mmodel parsedTree)
				         asArray) } asDictionary ].
	finalResult amplifiedMethods: info asArray
]

{ #category : #actions }
SAMainLoopDspot >> makeReadable [

	| readable reducer prettifier |
	reducer := (config oracleReducion initializeWith: config)
		           with: finalResult amplifiedClass
		           from: testClass smallAmpOriginalTestCase
		           target: targetClasses
		           uncovered:
		           (finalResult notCoveredInOriginal collect: #mutant).
	reducer ignoredTestMethods: finalResult failedSelectorInOriginal.
	readable := reducer makeReducedResult.
	finalResult oracleReductionReverts: reducer reverts.
	finalResult amplifiedMethods do: [ :methodInfo | 
		| newSelector |
		newSelector := reducer namesMapping at:
			               (methodInfo at: #selector_generated).
			methodInfo at: #selector_pretty put: newSelector
			 ].
	prettifier := config prettifier initializeWith: config.
	prettifier prettify: readable.
	^ readable
]

{ #category : #private }
SAMainLoopDspot >> methodProfiling [

	config profiler ifNotNil: [ 
		config profiler reset.
		self flag: #TODO. "why wee need cache profiles in config?"
		config profiler profileClasses: targetClasses byRunning: testClass.
		finalResult runProfile: config profiler ].
	(config inputAmplifiers anySatisfy: [ :kvp | 
		 (kvp key = SAInstantiationTransplanter) & (kvp value > 0) ]) ifTrue: [ 
		instantiationExtractor := SAObjectInstantiationExtractor new.
		instantiationExtractor testClass: testClass.
		instantiationExtractor run ]
]

{ #category : #private }
SAMainLoopDspot >> nextTest [

	^ nextTest
]

{ #category : #'as yet unclassified' }
SAMainLoopDspot >> prettifying [
	| prettifier |
	prettifier := config prettifier initializeWith: config.
			prettifier prettify: finalResult amplifiedClass
]

{ #category : #'as yet unclassified' }
SAMainLoopDspot >> rankedPopulation [

	^ (theTS select: [ :mtd | mtd score > 0 ]) sort: [ :a :b | 
		a score > b score ]
]

{ #category : #actions }
SAMainLoopDspot >> regenerateMethod: aMethodName [
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

{ #category : #'as yet unclassified' }
SAMainLoopDspot >> scoreMuthodsUnderTestBy: uncovered [

	| methodsScore |
	methodsScore := Dictionary new.
	uncovered do: [ :mutant | 
		| currentScore |
		currentScore := methodsScore
			                at: mutant mutant originalMethod
			                ifAbsentPut: 0.
		methodsScore at: mutant mutant originalMethod put: currentScore + 1 ].
	^ methodsScore
]

{ #category : #'as yet unclassified' }
SAMainLoopDspot >> scoreTestsWithUncovered: uncovered [

	^ self scoreTestsWithUncovered: uncovered randomGen: Random new
]

{ #category : #'as yet unclassified' }
SAMainLoopDspot >> scoreTestsWithUncovered: uncovered randomGen: randomGen [

	| methodsScore random tmp sumScores |
	nextTest := nil.
	sumScores := 0.
	tmp := 0.
	random := randomGen next.
	uncovered ifEmpty: [ ^ self ].
	methodsScore := self scoreMuthodsUnderTestBy: uncovered.
	(theTS reject: #isAmplified) do: [ :testModel | 
		testModel scoreWith: methodsScore.
		sumScores := sumScores + testModel score ].
	sumScores = 0 ifTrue: [ ^ self ].
	(theTS reject: #isAmplified) do: [ :testModel | 
		testModel score: testModel score / sumScores.
		tmp <= random & (random < (tmp + testModel score)) ifTrue: [ 
			nextTest := testModel ].
		tmp := tmp + testModel score ]
]

{ #category : #actions }
SAMainLoopDspot >> selectionFrom: aList [
	
	aList ifEmpty: [ ^ {} ].
			^ selection select: aList 
]

{ #category : #'as yet unclassified' }
SAMainLoopDspot >> setupSelection [

	| analysis testClasses testResult |
	selection := config selection initializeWith: config.
	testClasses := OrderedCollection with: testClass.
	testClass smallAmpOriginalTestCase = testClass ifFalse: [ 
		testClasses add: testClass smallAmpOriginalTestCase ].
	analysis := selection
		            initialAnalysisFor: testClasses
		            targets: targetClasses
		            ignore: finalResult failedSelectorInOriginal.
	finalResult originalAnalysis: analysis.
	selection uncovered ifEmpty: [ SANoUncovered new signal ].
	testResult := testClass suite run.
	testResult defects ifNotEmpty: [ SAFlakyMutationTesting new signal ]
]

{ #category : #private }
SAMainLoopDspot >> theTS: anObject [

	theTS := anObject
]

{ #category : #accessing }
SAMainLoopDspot >> timeBudgetFinished [
	super timeBudgetFinished.
	finalResult timeBudgetFinished: true.
]

{ #category : #private }
SAMainLoopDspot >> uncovered [ 
	^ selection uncovered 
]

{ #category : #'as yet unclassified' }
SAMainLoopDspot >> variableTypesProfile: testMethodModel [
	variableTypes := (SAVariableTypeProfiler initializeWith: config)
		testMethods: {testMethodModel testMethod};
		testClass: testMethodModel testClass;
		run;
		variablesTypes
]
