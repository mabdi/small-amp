Class {
	#name : #SAMainLoopSnapshotsFast,
	#superclass : #SAMainLoopDspot,
	#category : #'SmallAmp-Core'
}

{ #category : #actions }
SAMainLoopSnapshotsFast >> amplify [ 
	self heartbeat.
	^ super amplify 
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshotsFast >> amplifyATestMethod: aTestMethod initialAssertionAmplification: doInitialAssertionAmplification [
	self heartbeat.
	self setTestMethodStarting: aTestMethod.
	self snapshotHere: aTestMethod.
	(self isRecoveredFromCrash: aTestMethod) ifTrue: [ ^ self ].
	super
		amplifyATestMethod: aTestMethod
		initialAssertionAmplification: doInitialAssertionAmplification
]

{ #category : #private }
SAMainLoopSnapshotsFast >> assertionAmplificationFor: aList [
	self careTimeBudget ifFalse: [ ^ {  } ].
	aList
		do: [ :tcase | 
			self careTimeBudget ifFalse: [ tcase testMethod: nil ]
			ifTrue: [
				self
				saveCrashEvidence:
					{(#testClass -> tcase testClass name).
					(#testMethod -> tcase testMethod)} asDictionary.
					.tcase assertionAmplifyBy: assertAmplifier
				].
			 ]
		
		displayingProgress: 'Assertion Amplification' , ' (' , aList size asString , ')'.
	^ aList reject: [ :tcase | tcase testMethod isNil ]
	
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshotsFast >> careTimeBudget [
		self heartbeat.
		^ super careTimeBudget
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshotsFast >> doInitialAssertionAmplification [

	SmallAmp <~ ('AA0 ' , DateAndTime now asString).
	self heartbeat.
	SmallAmp <~ ('AA1 ' , DateAndTime now asString).
	^ super doInitialAssertionAmplification
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshotsFast >> evidenceFile [
	^ FileLocator imageDirectory / '_smallamp_crash_evidence.json'
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshotsFast >> filenameForCurrentTest [
	^ FileLocator imageDirectory / '_smallamp_current_method_'
]

{ #category : #actions }
SAMainLoopSnapshotsFast >> finalCoverage [

	self heartbeat.
	^ super finalCoverage
]

{ #category : #actions }
SAMainLoopSnapshotsFast >> finalSteps [
	self heartbeat .
	^ super finalSteps 
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshotsFast >> heartbeat [

		| str |
	str := 'beat'.
	self heartbeatFile writeStream
		truncate;
		nextPutAll: str;
		close
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshotsFast >> heartbeatFile [

	^ FileLocator imageDirectory / '_smallamp_heartbeat.file'
]

{ #category : #actions }
SAMainLoopSnapshotsFast >> initTs [ 
	self heartbeat.
	^ super initTs.
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshotsFast >> isRecoveredFromCrash: aTestMethod [
	| file current |
	file := self filenameForCurrentTest.
	current := file contents.
	current = aTestMethod selector
		ifTrue: [ ^ false ]
		ifFalse: [ SmallAmp
				<~
					('Recovered from a crash - skipping test method: '
						, aTestMethod selector).
			^ true ]
]

{ #category : #actions }
SAMainLoopSnapshotsFast >> makeReadable: readable reducer: reducer [

	self heartbeat.
	^ super makeReadable: readable reducer: reducer
]

{ #category : #private }
SAMainLoopSnapshotsFast >> methodProfiling [ 
	self heartbeat.
	^ super methodProfiling 
]

{ #category : #actions }
SAMainLoopSnapshotsFast >> reduceOracles [

	self heartbeat.
	^ super reduceOracles
]

{ #category : #private }
SAMainLoopSnapshotsFast >> saveCrashEvidence: aDictionary [

	| str |
	self heartbeat.
	str := STONJSON toString: aDictionary.
	self evidenceFile writeStream
		truncate;
		nextPutAll: str;
		close
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshotsFast >> scoreTestsWithUncovered: uncovered [

	self heartbeat.
	^ super scoreTestsWithUncovered: uncovered 
]

{ #category : #actions }
SAMainLoopSnapshotsFast >> selectionFrom: aList [
	
	aList ifEmpty: [ ^ {} ].
	^ selection selectSnapshot: aList
]

{ #category : #initialization }
SAMainLoopSnapshotsFast >> setTestMethodStarting: aTestMethod [
	| file |
	file := self filenameForCurrentTest.
	file exists
		ifTrue: [ file delete ].
	self filenameForCurrentTest writeStream
		truncate;
		nextPutAll: aTestMethod selector;
		close
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshotsFast >> setupSelection [

	| analysis testClasses testResult |
	self heartbeat.
	selection := config selection initializeWith: config.
	selection onBeforeMutant: [ :mutant :index | 
		self saveCrashEvidence: { 
				(#testClass -> testClass name).
				(#mutant -> mutant asDictionaryObject) } asDictionary ].
	selection onMutationEvaluation: [ self heartbeat.0 ].
	testClasses := OrderedCollection with: testClass.
	testClass smallAmpOriginalTestCase = testClass ifFalse: [ 
		testClasses add: testClass smallAmpOriginalTestCase ].
	self heartbeat.
	analysis := selection
		            initialAnalysisFor: testClasses
		            targets: targetClasses
		            ignore: finalResult failedSelectorInOriginal.
	self heartbeat.
	finalResult originalAnalysis: analysis.
	selection uncovered ifEmpty: [ SANoUncovered new signal ].
	testResult := testClass suite run.
	testResult defects ifNotEmpty: [ SAFlakyMutationTesting new signal ]
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshotsFast >> snapshotHere: aTestMethod [
	self heartbeat.
	self evidenceFile exists ifTrue: [ self evidenceFile delete ].
	Smalltalk snapshot: true andQuit: false
]
