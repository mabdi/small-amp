Class {
	#name : #SAMainLoopDspot,
	#superclass : #SAMainLoop,
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SAMainLoopDspot >> amplify [
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
			self normalize.
			self inputAmplification.
			self assertionAmplification.
			self selection.
			self cleanUpAndAddToResult ]
		displayingProgress: 'Main loop' , ' (' , config iterations asString , ')'.
	self finalSteps.
	^ finalResult
]

{ #category : #actions }
SAMainLoopDspot >> finalSteps [
	|generatedClass|
	generatedClass := self astHelper
				buildTestClassWith: (resultPeople collect: [ :tcase | tcase testMethod ])
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
