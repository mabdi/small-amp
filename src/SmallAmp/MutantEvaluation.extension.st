Extension { #name : #MutantEvaluation }

{ #category : #'*SmallAmp' }
MutantEvaluation >> runTestsSmallAmp [
	"Collect all suite test and execute them."

	| suite |
	suite := TestSuite named: 'MutationEvaluation'.
	suite
		addTests:
			((strategy testCasesToEvaluate: mutation for: self)
				collect: [ :each | each testCase ]).
	^ [ suite run ]
		on: Error
		do: [ :ex | nil ]
]

{ #category : #'*SmallAmp' }
MutantEvaluation >> testResultsSmallAmp [
	^ [ self runTestsSmallAmp ]
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
	self testResultsSmallAmp ]
		ensure: [ mutation uninstall ].
	^ MutantEvaluationResult
		for: mutation
		results: testResults
		producedBy: self
]
