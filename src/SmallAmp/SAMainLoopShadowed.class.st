Class {
	#name : #SAMainLoopShadowed,
	#superclass : #SAMainLoop,
	#instVars : [
		'theTS',
		'theATS',
		'theV',
		'theU'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SAMainLoopShadowed >> getTestModelFromTSBySelector: selector [
	| x |
	x := theTS select: [ :m | m selector = selector ].
	x
		ifEmpty: [ self
				error: 'Selector not found in TS: ' , selector , ' ts: ' , theTS asString ].
	x size > 1
		ifTrue: [ self error ].
	^ x first
]

{ #category : #actions }
SAMainLoopShadowed >> initTs [
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
	finalResult numberOfOriginalTestMethods: testMethods size.
	^ testMethods
		collect: [ :tcase | 
			(SATestMethod with: tcase class: testClass targets: targetClasses)
				selectorAppend: '_amp';
				yourself ]
]

{ #category : #private }
SAMainLoopShadowed >> inputAmplificationFrom: pop [
	| applyTransformation newcodes tmp amps |
	amps := self inputAmplifiers.
	newcodes := OrderedCollection new.
	applyTransformation := [ :amplifier :tcase | 
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
	tmp := (pop size > (config maxPop / 2)) 
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

{ #category : #'as yet unclassified' }
SAMainLoopShadowed >> makeReadable [
	| readable reducer prettifier |
	reducer := (config oracleReducion initializeWith: config)
		with: finalResult amplifiedClass
		from: testClass
		target: targetClasses
		uncovered: finalResult notCoveredInOriginal.
	reducer ignoredTestMethods: finalResult failedSelectorInOriginal.
	readable := reducer makeReducedResult.
	prettifier := config prettifier initializeWith: config.
	prettifier prettify: readable.
	self astHelper moveClassToFinal: readable.
]

{ #category : #actions }
SAMainLoopShadowed >> selectionFrom: aList [
	aList ifEmpty: [ ^ {} ].
			^ selection select: aList 
]

{ #category : #'as yet unclassified' }
SAMainLoopShadowed >> stepAssertAmplification [
	theU := self assertionAmplificationFor: (theV collect: #clone)
]

{ #category : #actions }
SAMainLoopShadowed >> stepFinalize [
	| generatedClass |
	generatedClass := self astHelper
		buildTestClassAndLogWith: (resultPeople collect: #testMethod)
		using: testClass.
	finalResult amplifiedClass: generatedClass.
	self astHelper moveClassToFinal: finalResult amplifiedClass.
	"self makeReadable."
	finalResult
		amplifiedAnalysis:
			(selection
				analysisFor: {finalResult amplifiedClass}
				targets: targetClasses
				ignore: finalResult failedSelectorInOriginal).
	finalResult saveResultToFileAs: testClass name.
	finalResult amplifiedClass fileOut
]

{ #category : #'as yet unclassified' }
SAMainLoopShadowed >> stepFinalizeTestMethod [
	theATS := theATS
		collect: [ :item | 
			| c |
			c := item cleanedUpCopy.
			c signAsSmallAmp.
			c ].
	resultPeople addAll: theATS
]

{ #category : #'as yet unclassified' }
SAMainLoopShadowed >> stepInitAmplifyATestMethod: aSelector [
	| aTestMethod |
	aTestMethod := self getTestModelFromTSBySelector: aSelector.
	theATS := OrderedCollection new.
	theV := OrderedCollection with: aTestMethod.
	theU := OrderedCollection new.
	theV do: #strip
]

{ #category : #'as yet unclassified' }
SAMainLoopShadowed >> stepInitClass [
	theTS := self initTs.
	self setupSelection.
	self methodProfiling.
	self flag: #todo	"write theTS to file -- accessible from runner"
]

{ #category : #'as yet unclassified' }
SAMainLoopShadowed >> stepInputAmplification [
	theV := self inputAmplificationFrom: theV
]

{ #category : #steps }
SAMainLoopShadowed >> stepSelection [
	theU := self selectionFrom: theU.
	theATS addAll: theU
]
