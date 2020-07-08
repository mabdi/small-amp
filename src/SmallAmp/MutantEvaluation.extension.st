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
	^ [ [ suite runStoppingOnFirstFailOrError ]
		on: Exception
		do: [ :x | 
			x isResumable
				ifTrue: [ x resume ]
				ifFalse: [ x signal ] ] ]
		on: Exception
		do: [ :ex | nil ]
]

{ #category : #'*SmallAmp' }
MutantEvaluation >> runTestsSmallAmpVerbose [
	"Collect all suite test and execute them."

	| suite |
	suite := TestSuite named: 'MutationEvaluation'.
	suite
		addTests:
			((strategy testCasesToEvaluate: mutation for: self)
				collect: [ :each | each testCase ]).
	^ [ [suite run]on: Exception
		do: [ :x | 
			x isResumable
				ifTrue: [ x resume ]
				ifFalse: [ x signal ] ]  ]
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
	self testResultsSmallAmp ]
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
