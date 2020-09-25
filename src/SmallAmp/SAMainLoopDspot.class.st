Class {
	#name : #SAMainLoopDspot,
	#superclass : #SAMainLoop,
	#instVars : [
		'theATS',
		'theTS'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SAMainLoopDspot >> amplify [
	theATS := OrderedCollection new.
	theTS := self initTs.
	theTS
		do: [ :aTestMethod | self amplifyATestMethod: aTestMethod ]
		displayingProgress: [ :aTestMethod | 'Amplifying: ' , aTestMethod selector ].
	self finalSteps.
	^ finalResult
]

{ #category : #'as yet unclassified' }
SAMainLoopDspot >> amplifyATestMethod: aTestMethod [
	| theV theU theTMP |
	theV := OrderedCollection with: aTestMethod.
	theV := self assertionAmplificationFor: theV.
	theU := self selectionFrom: theV.
	theATS addAll: theU.
	theTMP := theV.
	self cleanUpAndAddToResult.
	(1 to: config iterations)
		do: [ :gen | 
			theV := OrderedCollection new.
			theV := self inputAmplificationFrom: theTMP.
			theV := self assertionAmplificationFor: theV.
			theU := self selectionFrom: theV.
			theATS addAll: theU.
			theTMP := theV ]
		displayingProgress: 'Main loop' , ' (' , config iterations asString , ')'.
	theATS := theATS collect: #cleanedUpCopy.
	resultPeople
		addAll:
			(theATS
				collect: [ :item | 
					| c |
					c := item clone.
					c signAsSmallAmp.
					c ]).
]

{ #category : #actions }
SAMainLoopDspot >> finalSteps [
	| generatedClass |
	generatedClass := self astHelper
		buildTestClassWith: (resultPeople collect: #testMethod)
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
	^ testMethods
		collect: [ :tcase | 
			(SATestMethod with: tcase class: testClass targets: targetClasses)
				selectorAppend: '_amp';
				yourself ]
]

{ #category : #private }
SAMainLoopDspot >> inputAmplificationFrom: pop [
	| newcodes tmp |
	finalResult logs
		recoredTag: #inputAmplification
		toRun: [ newcodes := OrderedCollection new.
			tmp := pop size > config maxPop
				ifTrue: [ pop shuffle takeFirst: config maxPop ]
				ifFalse: [ pop ].
			tmp
				do: [ :tcase |
					tcase strip.
					tcase normalize .
					self inputAmplifiers
						do: [ :amplifier | newcodes addAll: (tcase inputAmplifyBy: amplifier) ] ]
				displayingProgress: 'Input Amplification' , ' (' , tmp size asString , ')'.
			^ newcodes ]
]

{ #category : #accessing }
SAMainLoopDspot >> inputAmplifiers [
	^ {SAAddInputAmplifier.
	SADspotLiteralInputAmplifier}
		collect: [ :amplifier | amplifier initializeWith: config ]
]
