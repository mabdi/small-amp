Extension { #name : #MutationTestingAnalysis }

{ #category : #'*SmallAmp' }
MutationTestingAnalysis >> generateResultsSmallAmp [
	particularResults := OrderedCollection new.
	mutations
		do: [ :aMutation | 
			logger logStartEvaluating: aMutation.
			particularResults
				add:
					(MutantEvaluation
						for: aMutation
						using: testCases
						following: mutantsEvaluationStrategy
						andConsidering: self coverageAnalysisResult) valueSmallAmp ]
		displayingProgress: 'Evaluating mutants'.
	^ particularResults
]

{ #category : #'*SmallAmp' }
MutationTestingAnalysis >> runSmallAmp [
	"Obtain mutants applying the operators in the classes (or
	methods of
	those classes) and execute all mutants in the set of testClases.
	We obtain a result for each mutant generated"

	^ [ (mutantsEvaluationStrategy testCasesToEvaluate: testCases for: self) do: [ :aTestCase | aTestCase run ].
	logger logAnalysisStartFor: self.
	elapsedTime := Time
		millisecondsToRun: [ self generateCoverageAnalysis.
			self generateMutations.
			self generateResultsSmallAmp ].
	true ]
		on: TestsWithErrorsException
		do: [ :ex | 
			self
				inform: 'Your tests have Errors or Failures. Please correct them.'.
			ex return: false ]
]

{ #category : #'*SmallAmp' }
MutationTestingAnalysis >> ui [ 
	| alive browser |
	alive := self generalResult aliveMutants.

"Display result in Glamorous Browser"
browser := GLMTabulator new.
browser 
	row: #results;
	row: #diff.
browser transmit to: #results.
browser transmit to: #diff; from: #results; andShow: [ :a | 
	a diff display: [ :mutant | {((RBParser parseMethod: (mutant mutant originalSource)) formattedCode) . ((RBParser parseMethod: (mutant mutant modifiedSource)) formattedCode)}] ].
browser openOn: alive
]
