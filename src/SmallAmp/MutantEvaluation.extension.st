Extension { #name : #MutantEvaluation }

{ #category : #'*SmallAmp' }
MutantEvaluation >> runTestsSmallAmpVerbose [
	"Collect all suite test and execute them."

	| suite |
	suite := TestSuite named: 'MutationEvaluation'.
	suite
		addTests:
			((strategy testCasesToEvaluate: mutation for: self)
				collect: [ :each | each testCase ]).
	^ [ "run or runStoppingOnFirstFailOrError" suite run ]
		on: Error
		do: [ :ex | nil ]
]

{ #category : #'*SmallAmp' }
MutantEvaluation >> testResultsSmallAmpVerbose [
	^ [ self runTestsSmallAmpVerbose ]
		valueWithin: (strategy timeoutForTestsOf: self) milliSeconds
		onTimeout: [ nil ]
]

{ #category : #'*SmallAmp' }
MutantEvaluation >> valueSmallAmp [
	| testResults |
	Stdio stdout
		nextPutAll: mutation originalMethod name asString;
		lf;
		flush.
	self initializeCoverageResultIfNil.
	testResults := [ mutation install.
	self testResults ]
		ensure: [ mutation uninstallDeep ].
	^ MutantEvaluationResult
		for: mutation
		results: testResults
		producedBy: self
]

{ #category : #'*SmallAmp' }
MutantEvaluation >> valueSmallAmpVerbose [
	| testResults |
	Stdio stdout
		nextPutAll: mutation originalMethod name asString;
		lf;
		flush.
	self initializeCoverageResultIfNil.
	testResults := [ mutation install.
	self testResultsSmallAmpVerbose ]
		ensure: [ mutation uninstallDeep ].
	^ MutantEvaluationResult
		for: mutation
		results: testResults
		producedBy: self
]
