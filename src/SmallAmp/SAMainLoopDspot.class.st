Class {
	#name : #SAMainLoopDspot,
	#superclass : #SAMainLoop,
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SAMainLoopDspot >> amplify [
	| ts_start skip |
	ts_start := DateAndTime now.
	self initialSteps.
	self assertionAmplification.
	self selection.
	self cleanUpAndAddToResult.
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
				ifFalse: [ self normalize.
					self inputAmplification.
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

{ #category : #private }
SAMainLoopDspot >> inputAmplificationFrom: pop [
	| newcodes |
	finalResult logs
		recoredTag: #inputAmplification
		toRun: [ newcodes := OrderedCollection new.
			pop
				do: [ :tcase | 
					self inputAmplifiers
						do: [ :amplifier | newcodes addAll: (tcase inputAmplifyBy: amplifier) ] ]
				displayingProgress: 'Input Amplification' , ' (' , pop size asString , ')'.
			population addAll: newcodes ]
]

{ #category : #accessing }
SAMainLoopDspot >> inputAmplifiers [
	^ { SAAddInputAmplifier. SALiteralInputAmplifier  }
		collect: [ :amplifier | amplifier initializeWith: config ]
]
