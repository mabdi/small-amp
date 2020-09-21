Class {
	#name : #SAMainLoopSmallAmp,
	#superclass : #SAMainLoop,
	#instVars : [
		'seeds',
		'typeData'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SAMainLoopSmallAmp >> amplify [
	| skip |
	self initialSteps.
	population := seeds collect: #clone.
	self assertionAmplification.
	self selection.
	self cleanUpAndAddToResult.
	self methodProfilingBy: seeds.
	(1 to: config iterations)
		do: [ :gen | 
			skip := selection uncovered isEmpty.
			skip
				ifFalse: [ population := OrderedCollection new.
					(1 to: config waves size)
						do: [ :wave | self inputAmplificationFrom: self seedsAndPopulation wave: wave ]
						displayingProgress: 'Wave (' , config waves size asString , ')'.
					self assertionAmplification.
					self selection.
					self cleanUpAndAddToResult.
					self methodProfilingBy: population.
					seeds addAll: population ] ]
		displayingProgress: 'Main loop' , ' (' , config iterations asString , ')'.
	self oracleReduction.
	self finalSteps.
	^ finalResult
]

{ #category : #actions }
SAMainLoopSmallAmp >> discardFailingTests [
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
SAMainLoopSmallAmp >> inputAmplificationFrom: pop wave: wave [
	finalResult logs
		recoredTag: #inputAmplification
		toRun: [ | newcodes tmp allWeights ampWeights |
			pop
				do: [ :tcase | 
					tcase strip.
					tcase normalize ].
			newcodes := OrderedCollection new.
			allWeights := (config inputAmplifiers collect: #value) sum.
			ampWeights := config inputAmplifiers
				collect: [ :kvp | kvp key -> (kvp value / allWeights) ].
			ampWeights := ampWeights asDictionary.
			self inputAmplifiers
				do: [ :amplifier | 
					| share |
					share := (((config waves at: wave) / config waves sum)
						* config maxPop * (ampWeights at: amplifier class)) asInteger
						max: 1.
					amplifier isTransplantation
						ifTrue: [ amplifier instantiationPatterns: instantiationExtractor patterns ].
					tmp := pop.
					pop size > share
						ifTrue: [ tmp := pop shuffle takeFirst: share ].
					tmp := tmp
						flatCollect: [ :tcase | tcase inputAmplifyBy: amplifier ].
					newcodes addAll: (tmp shuffle takeFirst: share) ]
				displayingProgress: 'Input Amplification (' , self inputAmplifiers size asString , ')'.
			population addAll: newcodes ]
]

{ #category : #private }
SAMainLoopSmallAmp >> methodProfilingBy: aPopulation [
	| generatedClass |
	generatedClass := self astHelper
		buildTestClassWith: (aPopulation collect: [ :tcase | tcase testMethod ])
		using: testClass.
	typeData
		ifNil: [ typeData := SAProxyProfiler initializeWith: config.
			finalResult runProfile: typeData ].
	typeData profileClasses: targetClasses byRunning: generatedClass.
	instantiationExtractor
		ifNil: [ instantiationExtractor := SAObjectInstantiationExtractor new ].
	instantiationExtractor testClass: generatedClass.
	instantiationExtractor run
]

{ #category : #actions }
SAMainLoopSmallAmp >> seedsAndPopulation [
	^ population , (seeds collect: #clone)
	
]
