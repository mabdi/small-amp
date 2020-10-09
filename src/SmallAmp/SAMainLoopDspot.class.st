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
	| theATS theV theU theTMP |
	(self checkCachedFor: aTestMethod selector)
		ifTrue: [ ^ false ].
	theATS := OrderedCollection new.
	theV := OrderedCollection with: aTestMethod.
	finalResult logs
		recoredTag: #assertionAmplification
		toRun: [ theV do: #strip.
			"theV do: #removeAssertionsAndExtract."
			theV := self assertionAmplificationFor: theV ].
	finalResult logs
		recoredTag: #selection
		toRun: [ theU := self selectionFrom: theV.
			theATS addAll: theU ].
	theTMP := theV.
	(1 to: config iterations)
		do: [ :gen | 
			theV := OrderedCollection new.
			finalResult logs
				recoredTag: #inputAmplification
				toRun: [ theV := self inputAmplificationFrom: theTMP ].
			finalResult logs
				recoredTag: #assertionAmplification
				toRun: [ theV := self assertionAmplificationFor: theV ].
			finalResult logs
				recoredTag: #selection
				toRun: [ theU := self selectionFrom: theV.
					theATS addAll: theU ].
			theTMP := theV ]
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
	| newcodes tmp amps |
	amps := self inputAmplifiers.
	newcodes := OrderedCollection new.
	tmp := pop size > config maxPop
		ifTrue: [ (pop shuffle takeFirst: config maxPop) collect: #clone ]
		ifFalse: [ pop collect: #clone ].
	tmp
		do: [ :tcase | 
			| tmp2 |
			tmp2 := (config maxPop + 1 / tmp size) ceiling.
			tcase strip.
			tcase normalize.
			(amps shuffle takeFirst: (tmp2 min: amps size))
				do: [ :amplifier | 
					amplifier isTransplantation
						ifTrue: [ amplifier instantiationPatterns: instantiationExtractor patterns ].
					newcodes addAll: (tcase inputAmplifyBy: amplifier) ] ]
		displayingProgress: 'Input Amplification' , ' (' , tmp size asString , ')'.
	^ newcodes shuffle takeFirst: config maxPop
]

{ #category : #actions }
SAMainLoopDspot >> selectionFrom: aList [
	aList ifEmpty: [ ^ {} ].
			^ selection select: aList 
]
