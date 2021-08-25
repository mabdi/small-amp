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
		'variableTypes'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SAMainLoopDspot >> amplify [
	theTS := self initTs.
	self setupSelection.
	self methodProfiling.
	theTS
		do: [ :aTestMethod | 
			self amplifyATestMethod: aTestMethod ]
		displayingProgress: [ :aTestMethod | 'Amplifying: ' , aTestMethod selector ].
	self finalSteps.
	^ finalResult
]

{ #category : #'as yet unclassified' }
SAMainLoopDspot >> amplifyATestMethod: aTestMethod [

	| theATS theV theU |
	SmallAmp <~ aTestMethod selector.
	self variableTypesProfile: aTestMethod.
	theATS := OrderedCollection new.
	theV := OrderedCollection with: aTestMethod.
	theV do: #strip.
	theU := self assertionAmplificationFor: (theV collect: #clone).
	theU := self selectionFrom: theU.
	theATS addAll: theU.
	(1 to: config iterations)
		do: [ :gen | 
			SmallAmp <~ ('iteration: ', gen asString).
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

{ #category : #private }
SAMainLoopDspot >> assertionAmplificationFor: aList [
	aList
		do: [ :tcase | 
			tcase assertionAmplifyBy: assertAmplifier.
			 ]
		displayingProgress: 'Assertion Amplification' , ' (' , aList size asString , ')'.
	^ aList reject: [ :tcase | tcase testMethod isNil ]
]

{ #category : #actions }
SAMainLoopDspot >> finalSteps [

	| generatedClass readable |
	SmallAmp <~ 'final steps'.
	generatedClass := SAGenericMethods new
		                  buildTestClassAndLogWith:
		                  (resultPeople collect: #testMethod)
		                  using: testClass smallAmpOriginalTestCase.
	finalResult amplifiedClass: generatedClass.
	readable := self makeReadable.
	finalResult amplifiedClass: readable.
	SAGenericMethods new moveClassToFinal: readable.
	finalResult amplifiedAnalysis: (selection
			 analysisFor: { finalResult amplifiedClass }
			 targets: targetClasses
			 ignore: finalResult failedSelectorInOriginal)
	"self installAmplifiedTests: readable"
]

{ #category : #actions }
SAMainLoopDspot >> initTs [
	| result testMethods |
	[ testRunTimeoutMillis := [ result := testClass suite run ] timeToRun
		asMilliSeconds ]
		valueWithin: config testRunTimeOut milliSeconds
		onTimeout: [ self error: 'Original test class timeout' ].
	testRunTimeoutMillis := {1000.
	testRunTimeoutMillis} max.
		assertAmplifier := config assertionAmplifier initializeWith: config.

	assertAmplifier testRunTimeoutMillis: testRunTimeoutMillis.
	testMethods := result expectedPasses
		collect:
			[ :passed | (passed class lookupSelector: passed selector) sourceCode ].
	finalResult
		failedSelectorInOriginal:
			(result failures , result expectedDefects
				collect: [ :failed | failed class lookupSelector: failed selector ])
				asOrderedCollection.
	testMethods ifEmpty: [ SANoGreenTest new signal ].
	finalResult numberOfOriginalTestMethods: testMethods size.
	^ testMethods
		collect: [ :tcase | 
			(SATestMethod with: tcase class: testClass targets: targetClasses)
				selectorAppend: '_amp';
				yourself ]
]

{ #category : #initialization }
SAMainLoopDspot >> initialize [
	super initialize.
	resultPeople := OrderedCollection new
]

{ #category : #private }
SAMainLoopDspot >> inputAmplificationFrom: pop [
	| applyTransformation newcodes tmp amps |
	amps := self inputAmplifiers.
	newcodes := OrderedCollection new.
	applyTransformation := [ :amplifier :tcase | 
	amplifier isTypeSensitive
		ifTrue: [ amplifier variableTypes: variableTypes ].
	amplifier isTransplantation
		ifTrue: [ amplifier instantiationPatterns: instantiationExtractor patterns ].
	newcodes addAll: (tcase inputAmplifyBy: amplifier) ].
	tmp := (pop collect: #clone)
		do: [ :tcase | 
			tcase strip.
			tcase normalize ].
	amps
		do: [ :amp | 
			| tmp2 |
			tmp2 := (config maxPop / 2 / amps size) ceiling.
			(pop shuffle takeFirst: (tmp2 min: pop size))
				do: [ :tcase | applyTransformation value: amp value: tcase ] ]
		displayingProgress: 'Input Amplification half 1' , ' (' , amps size asString , ')'.
	tmp := pop size > (config maxPop / 2)
		ifTrue: [ tmp shuffle takeFirst: config maxPop / 2 ]
		ifFalse: [ tmp ].
	tmp
		do: [ :tcase | 
			| tmp2 |
			tmp2 := ((config maxPop / 2 + 1) / tmp size) ceiling.
			(amps shuffle takeFirst: (tmp2 min: amps size))
				do: [ :amp | applyTransformation value: amp value: tcase ] ]
		displayingProgress: 'Input Amplification half 2' , ' (' , tmp size asString , ')'.
	^ newcodes shuffle takeFirst: config maxPop
]

{ #category : #accessing }
SAMainLoopDspot >> inputAmplifiers [
	^ config inputAmplifiers
		collect: [ :amplifier | amplifier key initializeWith: config ]
]

{ #category : #actions }
SAMainLoopDspot >> makeReadable [
	| readable reducer prettifier |
	reducer := (config oracleReducion initializeWith: config)
		with: finalResult amplifiedClass
		from: testClass smallAmpOriginalTestCase
		target: targetClasses
		uncovered: finalResult notCoveredInOriginal.
	reducer ignoredTestMethods: finalResult failedSelectorInOriginal.
	readable := reducer makeReducedResult.
	prettifier := config prettifier initializeWith: config.
	prettifier prettify: readable.
	^ readable
]

{ #category : #private }
SAMainLoopDspot >> methodProfiling [
	config profiler
		ifNotNil: [ config profiler reset.
			self flag: #TODO.	"why wee need cache profiles in config?"
			config profiler profileClasses: targetClasses byRunning: testClass.
			finalResult runProfile: config profiler ].
	instantiationExtractor := SAObjectInstantiationExtractor new.
	instantiationExtractor testClass: testClass.
	instantiationExtractor run
]

{ #category : #'as yet unclassified' }
SAMainLoopDspot >> prettifying [
	| prettifier |
	prettifier := config prettifier initializeWith: config.
			prettifier prettify: finalResult amplifiedClass
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

{ #category : #actions }
SAMainLoopDspot >> selectionFrom: aList [
	aList ifEmpty: [ ^ {} ].
			^ selection select: aList 
]

{ #category : #'as yet unclassified' }
SAMainLoopDspot >> setupSelection [
	selection := config selection initializeWith: config.
	finalResult
		originalAnalysis:
			(selection
				initialAnalysisFor: {testClass smallAmpOriginalTestCase}
				targets: targetClasses
				ignore: finalResult failedSelectorInOriginal).
	selection uncovered ifEmpty: [ SANoUncovered new signal ]
]

{ #category : #'as yet unclassified' }
SAMainLoopDspot >> variableTypesProfile: testMethodModel [
	variableTypes := (SAVariableTypeProfiler initializeWith: config)
		testMethods: {testMethodModel testMethod};
		testClass: testMethodModel testClass;
		run;
		variablesTypes
]
