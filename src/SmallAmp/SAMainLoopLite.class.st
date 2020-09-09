Class {
	#name : #SAMainLoopLite,
	#superclass : #SAMainLoop,
	#category : #'SmallAmp-Core'
}

{ #category : #actions }
SAMainLoopLite >> amplify [
	self initialSteps.
	self liteAmplification.
	self oracleReduction.
	^ finalResult
]

{ #category : #actions }
SAMainLoopLite >> amplifyLite [
	self initialSteps.
	self liteAmplification.
	self oracleReduction.
	^ finalResult
]

{ #category : #private }
SAMainLoopLite >> liteAmplification [
	| aPopulation old_Pop |
	finalResult logs
		recoredTag: #liteAmplification
		toRun: [ aPopulation := population
				collect: [ :tcase | tcase renamedCopy: '_amp' ].
			aPopulation do: [ :tcase | tcase strip ].
			aPopulation
				do: [ :tcase | 
					self assertionAmplifiers
						do: [ :amplifier | amplifier testRunTimeoutMillis: testRunTimeoutMillis . tcase assertionAmplifyBy: amplifier ] ]
				displayingProgress: 'Assertion Amplification' , ' (' , aPopulation size asString , ')'.
			old_Pop := population.
			population := aPopulation reject: [ :x | x testMethod isNil ].
			self selection.
			self cleanUpAndAddToResult.
			"population addAll: old_Pop ???"
			population := old_Pop ]
]
