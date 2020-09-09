Class {
	#name : #SAMainLoopKeepSeed,
	#superclass : #SAMainLoop,
	#instVars : [
		'seeds'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #adding }
SAMainLoopKeepSeed >> addPopulationToResult [
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
SAMainLoopKeepSeed >> amplify [
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
				ifFalse: [ self setupPopulation.
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

{ #category : #cleanup }
SAMainLoopKeepSeed >> cleanUpAndAddToResult [
	finalResult logs
		recoredTag: #cleanUpAndAddToResult
		toRun: [ population := population collect: [ :obj | obj cleanedUpCopy ].
			self addPopulationToResult ]
]

{ #category : #actions }
SAMainLoopKeepSeed >> discardFailingTests [
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
SAMainLoopKeepSeed >> inputAmplification [
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

{ #category : #actions }
SAMainLoopKeepSeed >> setupPopulation [
	population := seeds
		collect: [ :item | 
			| c |
			c := item clone.
			c ]
]
