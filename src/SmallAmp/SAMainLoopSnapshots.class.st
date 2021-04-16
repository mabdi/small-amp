Class {
	#name : #SAMainLoopSnapshots,
	#superclass : #SAMainLoop,
	#instVars : [
		'theTS'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SAMainLoopSnapshots >> amplify [
	theTS := self initTs.
			self setupSelection.
			self methodProfiling.
	theTS
		do: [ :aTestMethod | 
			SALogger logConsole: aTestMethod selector.
			self amplifyATestMethod: aTestMethod ]
		displayingProgress: [ :aTestMethod | 'Amplifying: ' , aTestMethod selector ].
	self finalSteps.
	^ finalResult
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshots >> amplifyATestMethod: aTestMethod [
	| theATS theV theU |
	theATS := OrderedCollection new.
	theV := OrderedCollection with: aTestMethod.
	theV do: #strip.
	theU := self assertionAmplificationFor: (theV collect: #clone).
	theU := self selectionFrom: theU.
	theATS addAll: theU.
	(1 to: config iterations)
		do: [ :gen |
					theV := self inputAmplificationFrom: theV.
			
					theU := self assertionAmplificationFor: (theV collect: #clone).
			
					theU := self selectionFrom: theU.
					theATS addAll: theU  ]
		displayingProgress: 'Main loop' , ' (' , config iterations asString , ')'.
	theATS := theATS
		collect: [ :item | 
			| c |
			c := item cleanedUpCopy.
			c signAsSmallAmp.
			c ].
	resultPeople addAll: theATS
]

{ #category : #private }
SAMainLoopSnapshots >> assertionAmplificationFor: aListInput [
	| toSkip aList |
	aList := aListInput.
	toSkip := OrderedCollection new.
	self snapshotPoint: #assertion_amplification.
	self restoreState
		ifNotNil: [ :state | 
			aList := state at: #aList.
			toSkip := state at: #toSkip ].
	aList
		do: [ :tcase | 
			(toSkip includes: tcase)
				ifFalse: [ self
						saveTheState:
							{(#aList -> aList).
							(#toSkip
								->
									(toSkip
										add: tcase;
										yourself))} asDictionary.
					self assertionAmplifiers
						do: [ :amplifier | 
							assertAmplificationClassCache
								ifNotNil: [ amplifier generatedClass: assertAmplificationClassCache ].
							amplifier testRunTimeoutMillis: testRunTimeoutMillis.
							tcase assertionAmplifyBy: amplifier.
							assertAmplificationClassCache := amplifier generatedClass ] ] ]
		displayingProgress: 'Assertion Amplification' , ' (' , aList size asString , ')'.
	^ aList reject: [ :tcase | tcase testMethod isNil ]
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshots >> eventFile [
	^ FileLocator imageDirectory / '_smallamp_last_event.json'
]

{ #category : #actions }
SAMainLoopSnapshots >> finalSteps [
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
SAMainLoopSnapshots >> initTs [
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
SAMainLoopSnapshots >> inputAmplificationFrom: pop [
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
SAMainLoopSnapshots >> isEventPresent: anEvent [
	^ self eventFile exists
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshots >> makeReadable [
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
SAMainLoopSnapshots >> resetCurrentState [
	self stateFile exists
		ifTrue: [ self stateFile delete ]
]

{ #category : #private }
SAMainLoopSnapshots >> restoreState [
	self eventFile exists
		ifFalse: [ ^ nil ].
	^ FLMaterializer materializeFromFileNamed: self stateFile
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshots >> saveEvent: anEvent [
	| str |
	str := STONJSON toString: anEvent.
	(self eventFile) writeStream
		truncate;
		nextPutAll: str;
		close
]

{ #category : #private }
SAMainLoopSnapshots >> saveTheState: anState [
	FLSerializer serialize: anState on: self stateFile writeStream
]

{ #category : #actions }
SAMainLoopSnapshots >> selectionFrom: aList [
	aList ifEmpty: [ ^ {} ].
	^ selection select: aList
	
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshots >> setupSelection [
	super setupSelection.
	selection
		onBeforeMutant: [ :mutant | 
			self
				snapshot:
					{(#event -> #selection).
					(#mutant -> mutant asDictionaryObject)} asDictionary ]
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshots >> snapshot: anEvent [
	anEvent at: #testClass put: testClass name.
	self saveEvent: anEvent.
	Smalltalk snapshot: true andQuit: false.
	^ self isEventPresent: anEvent
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshots >> snapshotPoint: aPoint [
	| anEvent |
	anEvent := Dictionary new
		at: #event put: aPoint;
		at: #testClass put: testClass name;
		yourself.
	self saveEvent: anEvent.
	self resetCurrentState.
	Smalltalk snapshot: true andQuit: false
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshots >> stateFile [
	^ FileLocator imageDirectory / '_smallamp_last_state.fl'
]
