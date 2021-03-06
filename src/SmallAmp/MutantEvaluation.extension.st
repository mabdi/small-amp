Extension { #name : #MutantEvaluation }

{ #category : #'*SmallAmp' }
MutantEvaluation >> getTestClass [
	^ testCases first testCase class
]

{ #category : #'*SmallAmp' }
MutantEvaluation >> getTimeOut [
	^ (10 max: (strategy timeoutForTestsOf: self)) milliSeconds
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
	^ [ [ suite runStoppingOnFirstFailOrError ]
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
		valueWithin: self getTimeOut
		onTimeout: [ Stdio stdout
				nextPutAll: Time nowUTC print24;
				nextPutAll: String space;
				nextPutAll:
					'testResultsSmallAmpVerbose: Terminating test Due to timeout- millies: ';
				nextPutAll: (strategy timeoutForTestsOf: self) asString;
				<< 'coverage: ';
				<< coverageAnalysisResult class name;
				<< ' ';
				<< coverageAnalysisResult coveredMethods asString;
				lf;
				flush.
			nil ]
]

{ #category : #'*SmallAmp' }
MutantEvaluation >> testResultsSmallAmpVerbose [
	^ [ self runTestsSmallAmpVerbose ]
		valueWithin: self getTimeOut
		onTimeout: [ Stdio stdout
				nextPutAll: Time nowUTC print24;
				nextPutAll: String space;
				nextPutAll:
					'testResultsSmallAmpVerbose: Terminating test Due to timeout- millies: ';
				nextPutAll: (strategy timeoutForTestsOf: self) asString;
				<< 'coverage: ';
				<< coverageAnalysisResult coveredMethods;
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
	^ MutantEvaluationResult
		for: mutation
		results: testResults
		producedBy: self
]
