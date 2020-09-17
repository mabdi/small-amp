Class {
	#name : #SAMainLoopTwoWave,
	#superclass : #SAMainLoop,
	#instVars : [
		'seeds'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #adding }
SAMainLoopTwoWave >> addPopulationToResult [
	| newElites |
	newElites := population
		collect: [ :item | 
			| c |
			c := item clone.
			c signAsSmallAmp.
			c ].
	resultPeople addAll: newElites.
	seeds addAll: newElites
]

{ #category : #'as yet unclassified' }
SAMainLoopTwoWave >> amplify [
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
				ifFalse: [ | pop |
					self setupPopulation.
					self normalize.
					pop := population collect: #clone.
					self inputAmplificationFrom: pop.
					self inputTransplantationFrom: pop.
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

{ #category : #cleanup }
SAMainLoopTwoWave >> cleanUpAndAddToResult [
	finalResult logs
		recoredTag: #cleanUpAndAddToResult
		toRun: [ population := population collect: [ :obj | obj cleanedUpCopy ].
			self addPopulationToResult ]
]

{ #category : #actions }
SAMainLoopTwoWave >> discardFailingTests [
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
	seeds := testMethods
		collect: [ :tcase | 
			(SATestMethod with: tcase class: testClass targets: targetClasses)
				selectorAppend: '_amp';
				yourself ]
]

{ #category : #private }
SAMainLoopTwoWave >> inputAmplificationFrom: pop [
	| newcodes halfPop |
	finalResult logs
		recoredTag: #inputAmplification
		toRun: [ | popsize |
			popsize := config maxPopPerMethod
				ifNotNil: [ :permethod | permethod * pop  size min: config maxPop ]
				ifNil: [ config maxPop ].
			halfPop := popsize / 2.
			newcodes := OrderedCollection new.
			pop
				do: [ :tcase | 
					| inputs |
					inputs := self inputAmplifiers
						flatCollect: [ :amplifier | tcase inputAmplifyBy: amplifier ].
					newcodes
						addAll: (inputs shuffle first: (config maxPopPerMethod / 2 min: inputs size)) ]
				displayingProgress: 'Input Amplification' , ' (' , pop  size asString , ')'.
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

{ #category : #private }
SAMainLoopTwoWave >> inputTransplantationFrom: pop [
	| newcodes transplantor |
	finalResult logs
		recoredTag: #inputTransplantation
		toRun: [ newcodes := OrderedCollection new.
			transplantor := SAInstantiationTransplanter initializeWith: config.
			transplantor instantiationPatterns: instantiationExtractor patterns.
			pop
				do: [ :tcase | newcodes addAll: (tcase inputAmplifyBy: transplantor) ]
				displayingProgress: 'Input inputTransplantation' , ' (' , pop size asString , ')'.
			population addAll: newcodes ]
]

{ #category : #actions }
SAMainLoopTwoWave >> setupPopulation [
	population := seeds
		collect: [ :item | 
			| c |
			c := item clone.
			c ]
]
