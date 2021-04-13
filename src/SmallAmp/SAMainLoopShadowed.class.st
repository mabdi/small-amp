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

{ #category : #actions }
SAMainLoopShadowed >> amplify [
	^ self error: 'dont call me.'
]

{ #category : #'as yet unclassified' }
SAMainLoopShadowed >> getSelector: selector from: aList [
	| x |
	x := aList select: [ :m | m selector = selector ].
	x
		ifEmpty: [ self
				error: 'Selector not found: ' , selector , ' list: ' , aList asString ].
	x size > 1
		ifTrue: [ self error ].
	^ x first
]

{ #category : #'as yet unclassified' }
SAMainLoopShadowed >> getTestInputFromTheV: aSelector [
	^ self getSelector: aSelector from: theV
]

{ #category : #'as yet unclassified' }
SAMainLoopShadowed >> getTestModelFromTSBySelector: selector [
	^ self getSelector: selector from: theTS
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

{ #category : #'as yet unclassified' }
SAMainLoopShadowed >> stepAssertAmplification: aSelector [
	| tcase |
	tcase := (self getTestInputFromTheV: aSelector) clone.
	self assertionAmplifiers
		do: [ :amplifier | 
			" dirty  but necessary. recreating a temp class is very time cosuming "
			"^ aList reject: [ :tcase | tcase testMethod isNil ]"
			assertAmplificationClassCache
				ifNotNil: [ amplifier generatedClass: assertAmplificationClassCache ].
			amplifier testRunTimeoutMillis: testRunTimeoutMillis.
			tcase assertionAmplifyBy: amplifier.
			assertAmplificationClassCache := amplifier generatedClass ].
	tcase testMethod ifNotNil: [ theU add: tcase ]
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
	theV do: #strip.
	self updateFileTheV
]

{ #category : #'as yet unclassified' }
SAMainLoopShadowed >> stepInitClass [
	theTS := self initTs.
	self setupSelection.
	self methodProfiling.
	self updateFileTheTS.
	self updateFileUncovered
]

{ #category : #'as yet unclassified' }
SAMainLoopShadowed >> stepInputAmplification [
	theV := self inputAmplificationFrom: theV.
	self updateFileTheV 
]

{ #category : #steps }
SAMainLoopShadowed >> stepSelectionFinalize [
	theU := selection finalizeShadowSelections.
	theATS addAll: theU.
	self updateFileUncovered 
]

{ #category : #steps }
SAMainLoopShadowed >> stepSelectionInit [
	selection setUpShadowSelections.
]

{ #category : #steps }
SAMainLoopShadowed >> stepSelectionMutantIndex: anInteger [
	selection select: theU forMutantAtIndex: anInteger.
	
]

{ #category : #'as yet unclassified' }
SAMainLoopShadowed >> updateFileTheTS [
	self
		writeJsonToFile: '_smallamp_theTS'
		array: (theTS collect: [ :x | x selector asString ]) asArray
]

{ #category : #'as yet unclassified' }
SAMainLoopShadowed >> updateFileTheV [
	self
		writeJsonToFile: '_smallamp_theV'
		array: (theV collect: [ :x | x selector asString ])asArray
]

{ #category : #'as yet unclassified' }
SAMainLoopShadowed >> updateFileUncovered [
	self
		writeJsonToFile: '_smallamp_uncovered'
		array: (selection uncovered collect: [:m | m mutant asDictionaryObject])
]

{ #category : #writing }
SAMainLoopShadowed >> writeJsonToFile: name array: anArray [
	| str |
	str := STONJSON toString: anArray.
	(FileLocator imageDirectory / (name, '.json')) writeStream
		truncate;
		nextPutAll: str;
		close
]
