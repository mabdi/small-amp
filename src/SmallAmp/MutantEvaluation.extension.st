Extension { #name : #MutantEvaluation }

{ #category : #'*SmallAmp' }
MutantEvaluation >> getTestClass [
	^ testCases first testCase class
]

{ #category : #'*SmallAmp' }
MutantEvaluation >> runTestsSmallAmp [
	"Collect all suite test and execute them."

	| suite |
	suite := TestSuite named: 'MutationEvaluation'.
	suite
		addTests:
			((strategy testCasesToEvaluate: mutation for: self)
				collect: [ :each | each testCase ]).
	^ [ SAASTHelper new runSafely: [[ suite runStoppingOnFirstFailOrError ]
		on: Exception
		do: [ :x | 
			x isResumable
				ifTrue: [ x resume ]
				ifFalse: [ x signal ] ]] timeOut: 3 seconds  ]
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
	^ [ [ suite run ]
		on: Exception
		do: [ :x | 
			x isResumable
				ifTrue: [ x resume ]
				ifFalse: [ x signal ] ] ]
		on: Exception
		do: [ :ex | 
			Stdio stdout
				nextPutAll: Time nowUTC print24;
				nextPutAll: String space;
				nextPutAll: 'runTestsSmallAmpVerbose: Terminating test Run: ';
				nextPutAll: ex asString;
				lf;
				flush.
			nil ]
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
		onTimeout: [ 			Stdio stdout
				nextPutAll: Time nowUTC print24;
				nextPutAll: String space;
				nextPutAll: 'testResultsSmallAmpVerbose: Terminating test Due to timeout';
				lf;
				flush.
				nil ]
]

{ #category : #'*SmallAmp' }
MutantEvaluation >> valueSmallAmp [
	| testResults |
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
	self initializeCoverageResultIfNil.
	testResults := [ mutation install.
	self testResultsSmallAmpVerbose ]
		ensure: [ mutation uninstallDeep ].
	testResults
		ifNil: [ Stdio stdout
				nextPutAll: Time nowUTC print24;
				nextPutAll: String space;
				nextPutAll: 'testResults is nil';
				lf;
				flush ].
	^ MutantEvaluationResult
		for: mutation
		results: testResults
		producedBy: self
]
