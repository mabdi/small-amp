Class {
	#name : #SAMainLoopDspot,
	#superclass : #SAMainLoop,
	#instVars : [
		'theTS'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SAMainLoopDspot >> amplify [
	
	finalResult logs
		recoredTag: #init
		toRun: [ theTS := self initTs.
			self setupSelection.
			self methodProfiling ].
	theTS
		do: [ :aTestMethod | 
			SALogger logConsole: aTestMethod selector.
			self amplifyATestMethod: aTestMethod ]
		displayingProgress: [ :aTestMethod | 'Amplifying: ' , aTestMethod selector ].
	finalResult logs recoredTag: #finalize toRun: [ self finalSteps ].
	^ finalResult
]

{ #category : #'as yet unclassified' }
SAMainLoopDspot >> amplifyATestMethod: aTestMethod [
	| theATS theV theU |
	(self checkCachedFor: aTestMethod selector)
		ifTrue: [ ^ false ].
	theATS := OrderedCollection new.
	theV := OrderedCollection with: aTestMethod.
	finalResult logs
		recoredTag: #assertionAmplification
		toRun: [ theV do: #strip.
			"theV do: #removeAssertionsAndExtract."
			theU := self assertionAmplificationFor: (theV collect: #clone) ].
	finalResult logs
		recoredTag: #selection
		toRun: [ theU := self selectionFrom: theU.
			theATS addAll: theU ].
	(1 to: config iterations)
		do: [ :gen | 
			finalResult logs
				recoredTag: #inputAmplification
				toRun: [ theV := self inputAmplificationFrom: theV ].
			finalResult logs
				recoredTag: #assertionAmplification
				toRun: [ theU := self assertionAmplificationFor: (theV collect: #clone) ].
			finalResult logs
				recoredTag: #selection
				toRun: [ theU := self selectionFrom: theU.
					theATS addAll: theU ] ]
		displayingProgress: 'Main loop' , ' (' , config iterations asString , ')'.
	theATS := theATS
		collect: [ :item | 
			| c |
			c := item cleanedUpCopy.
			c signAsSmallAmp.
			c ].
	self cacheSelectedTests: theATS for: aTestMethod selector.
	resultPeople addAll: theATS
]

{ #category : #'as yet unclassified' }
SAMainLoopDspot >> cacheSelectedTests: aList for: aSelector [
	| fileName data tmp |
	config saveToFile
		ifFalse: [ ^ self ].
	fileName := self fileNameForSelector: aSelector.
	fileName exists
		ifTrue: [ fileName delete ].
	tmp := (aList
		collect: [ :m | ZnBase64Encoder new encode: m testMethod asByteArray ])
		asArray.
	data := {(#methods -> tmp)} asDictionary.
	fileName writeStream
		nextPutAll: (STONJSON toStringPretty: data);
		close
]

{ #category : #'as yet unclassified' }
SAMainLoopDspot >> checkCachedFor: aSelector [
	| theATS fileName data |
	config saveToFile
		ifFalse: [ ^ false ].
	fileName := self fileNameForSelector: aSelector .
	fileName exists
		ifTrue: [ fileName
				readStreamDo: [ :readStream | data := STONJSON fromStream: readStream ] ]
		ifFalse: [ ^ false ].
	theATS := (data at: #methods ifAbsent: [ ^ false ])
		collect: [ :item | 
			SATestMethod
				with: (ZnBase64Encoder new decode: item) asString
				class: testClass
				targets: targetClasses ].
	resultPeople addAll: theATS.
	^ true
]

{ #category : #private }
SAMainLoopDspot >> fileNameForSelector: aSelector [
	| fileName |
	fileName := FileLocator imageDirectory / 'smallAmp'.
	fileName ensureCreateDirectory.
	fileName := fileName / testClass name.
	fileName ensureCreateDirectory.
	fileName := fileName / (aSelector , '.json').
	^ fileName
]

{ #category : #actions }
SAMainLoopDspot >> finalSteps [
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
				ignore: finalResult failedSelectorInOriginal)
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
SAMainLoopDspot >> inputAmplificationFrom: pop [
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
SAMainLoopDspot >> makeReadable [
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
SAMainLoopDspot >> selectionFrom: aList [
	aList ifEmpty: [ ^ {} ].
			^ selection select: aList 
]
