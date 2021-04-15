Extension { #name : #MutationTestingAnalysis }

{ #category : #'*SmallAmp' }
MutationTestingAnalysis >> discardFailings [
	| fails |
	fails := OrderedCollection new.
	(mutantsEvaluationStrategy testCasesToEvaluate: testCases for: self)
		do: [ :aTestCase | 
			[ aTestCase run ]
				on: TestsWithErrorsException
				do: [ :ex | fails add: aTestCase ] ].
	testCases := testCases reject: [ :t  | fails includes: t ]
]

{ #category : #'*SmallAmp' }
MutationTestingAnalysis >> generateResultsLogger [
	particularResults := OrderedCollection new.
	mutations
		do: [ :aMutation | 
			logger logStartEvaluating: aMutation.
			[ particularResults
				add:
					(MutantEvaluationLogger
						for: aMutation
						using: testCases
						following: mutantsEvaluationStrategy
						andConsidering: self coverageAnalysisResult) value ]
				on: Error
				do: [ Stdio stdout
						nextPutAll: 'Mutation generation failed: ';
						nextPutAll: aMutation operator description;
						nextPutAll: 'Method: ';
						nextPutAll: aMutation originalMethod name asString;
						lf;
						flush ] ]
		displayingProgress: 'Evaluating mutants'.
	^ particularResults
]

{ #category : #'*SmallAmp' }
MutationTestingAnalysis >> generateResultsSmallAmp [
	particularResults := OrderedCollection new.
	mutations
		do: [ :aMutation | 
			logger logStartEvaluating: aMutation.
			[ particularResults
				add:
					(MutantEvaluation
						for: aMutation
						using: testCases
						following: mutantsEvaluationStrategy
						andConsidering: self coverageAnalysisResult) valueSmallAmp ]
				on: Error
				do: [ :x | 
					Stdio stdout
						nextPutAll: 'Mutation generation failed: ';
						nextPutAll: aMutation operator class name;
						nextPutAll: 'Method: ';
						nextPutAll: aMutation originalMethod name asString;
						<< ' ';
						<< x class name;
						<< ' ';
						<< x asString;
						lf;
						flush ] ]
		displayingProgress: 'Evaluating mutants'.
	^ particularResults
]

{ #category : #'*SmallAmp' }
MutationTestingAnalysis >> generateResultsSmallAmpVerbose [
	particularResults := OrderedCollection new.
	mutations
		do: [ :aMutation | 
			| continue |
			logger logStartEvaluating: aMutation.
			continue := true.
			mutationsGenerationStrategy onBeforeMutant
				ifNotNil: [ continue := mutationsGenerationStrategy onBeforeMutant
						value: aMutation ].
			continue ifTrue: 
[			[ particularResults
				add:
					(MutantEvaluation
						for: aMutation
						using: testCases
						following: mutantsEvaluationStrategy
						andConsidering: self coverageAnalysisResult)
						valueSmallAmpVerbose ]
				on: Error
				do: [ :x | 
					Stdio stdout
						nextPutAll: 'Mutation generation failed: ';
						nextPutAll: aMutation operator class name;
						nextPutAll: 'Method: ';
						nextPutAll: aMutation originalMethod name asString;
						<< ' ';
						<< x class;
						<< ' ';
						<< x asString;
						lf;
						flush ]] ]
		displayingProgress: 'Evaluating mutants'.
	^ particularResults
]

{ #category : #'*SmallAmp' }
MutationTestingAnalysis >> runSmallAmp [
	"Obtain mutants applying the operators in the classes (or
	methods of
	those classes) and execute all mutants in the set of testClases.
	We obtain a result for each mutant generated"

	^ [self discardFailings. logger logAnalysisStartFor: self.
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
MutationTestingAnalysis >> runSmallAmpVerbose [
	"Obtain mutants applying the operators in the classes (or
	methods of
	those classes) and execute all mutants in the set of testClases.
	We obtain a result for each mutant generated"

	^ [ self discardFailings.logger logAnalysisStartFor: self.
	elapsedTime := Time
		millisecondsToRun: [ self generateCoverageAnalysis.
			self generateMutations.
			self generateResultsSmallAmpVerbose ].
	true ]
		on: TestsWithErrorsException
		do: [ :ex | 
			self
				inform: 'Your tests have Errors or Failures. Please correct them.'.
			ex return: false ]
]

{ #category : #'*SmallAmp' }
MutationTestingAnalysis >> smallAmpCovered [
	^ self generalResult killedOrTerminatedMutants
]

{ #category : #'*SmallAmp' }
MutationTestingAnalysis >> smallAmpNewCovered: oldAnalysis [
	| g1 g2 |
	g1 := self generalResult.
	g2 := oldAnalysis generalResult.
	^ g1 killedMutants
		reject: [ :m | 
			(g2 killedMutants collect: [ :x | x mutant modifiedSource ])
				includes: m mutant modifiedSource ]
]

{ #category : #'*SmallAmp' }
MutationTestingAnalysis >> smallAmpScore [
	^ self generalResult mutationScore
]

{ #category : #'*SmallAmp' }
MutationTestingAnalysis >> smallAmpUncovered [
	^ self generalResult aliveMutants
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
