Class {
	#name : #SAMainLoopOneWave,
	#superclass : #SAMainLoop,
	#category : #'SmallAmp-Core'
}

{ #category : #'instance creation' }
SAMainLoopOneWave class >> with: aConfig for: aTestClass targets: targetClasses [
	^ self new
		  with: aConfig for: aTestClass targets: targetClasses;	
		  yourself
]

{ #category : #actions }
SAMainLoopOneWave >> amplify [
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
