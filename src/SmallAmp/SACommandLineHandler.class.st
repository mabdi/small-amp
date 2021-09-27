"
Usage: smallamp [ options ]
options: 
 	--stat=prefix               Calculates some statistics about packages with specified prefix
	--xinfo=testName
	--useSnapshots=testName     Amplify the specified test class, it snapshots the main to be able to recover after a crash
	--dspot=testName     			Amplify the specified test class
	--noquit                    Don't quite image after performing the operation
	--save                    	Save image after opertation
	
"
Class {
	#name : #SACommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : #'SmallAmp-Helpers'
}

{ #category : #accessing }
SACommandLineHandler class >> commandName [
	^ 'smallamp'
]

{ #category : #accessing }
SACommandLineHandler class >> description [
	^ 'Runs SmallAmp'
]

{ #category : #activation }
SACommandLineHandler >> activate [
	self activateHelp
		ifTrue: [ ^ self ].
	(self hasOption: 'stat')
		ifTrue: [ self evalStats ].
	(self hasOption: 'xinfo')
		ifTrue: [ self extraInformation ].
	(self hasOption: 'mode')
		ifTrue: [ self runInMode ].
	(self hasOption: 'resume')
		ifTrue: [ self resumeRunning ].
	self end
]

{ #category : #accessing }
SACommandLineHandler >> end [
	| noquit saveit |
	noquit := self commandLine hasOption: 'noquit'.
	saveit := self commandLine hasOption: 'save'.
	Smalltalk snapshot: saveit andQuit: noquit not.

]

{ #category : #'as yet unclassified' }
SACommandLineHandler >> evalStats [
	| prefix |
	prefix := self arguments detect: [ :arg | arg beginsWith: '--stat=' ].
	prefix := prefix allButFirst: '--stat=' size.
	SAGenericMethods new metricsEval: prefix
]

{ #category : #accessing }
SACommandLineHandler >> extraInformation [
	| testName res resstr fileName |
	self arguments
		detect: [ :arg | arg beginsWith: '--xinfo=' ]
		ifFound: [ :arg | testName := arg allButFirst: '--xinfo=' size ].
	res := SAGenericMethods new extraInformationFor: testName.
	resstr := STONJSON toStringPretty: res.
	fileName := testName , '.xjson'.
	(FileLocator imageDirectory / fileName) exists
		ifTrue: [ (FileLocator imageDirectory / fileName) delete ].
	(FileLocator imageDirectory / fileName) writeStream
		nextPutAll: resstr;
		close
]

{ #category : #'as yet unclassified' }
SACommandLineHandler >> resumeRunning [
	Semaphore new wait
]

{ #category : #'as yet unclassified' }
SACommandLineHandler >> runInMode [
	| cmd testClass timeBudget aTestClass mode cnf |
	cmd := '--testClass='.
	self arguments
		detect: [ :arg | arg beginsWith: cmd ]
		ifFound: [ :arg | testClass := arg allButFirst: cmd size ]
		ifNone: [ SmallAmp <~ '--testClass=TestClassName is required'.
			^ self ].
	cmd := '--timeBudget='.
	self arguments
		detect: [ :arg | arg beginsWith: cmd ]
		ifFound: [ :arg | timeBudget := (arg allButFirst: cmd size) asInteger ]
		ifNone: [ timeBudget := 0. ].
	cmd := '--mode='.
	self arguments
		detect: [ :arg | arg beginsWith: cmd ]
		ifFound: [ :arg | mode := arg allButFirst: cmd size ].
	aTestClass := Smalltalk globals at: testClass asSymbol.
	mode = 'dspotSnapshots'
		ifTrue: [ cnf := SAConfig dspotAllamps.
			cnf mainloop: SAMainLoopSnapshots ].
	mode = 'dspot'
		ifTrue: [ cnf := SAConfig dspotAllamps.
			cnf mainloop: SAMainLoopDspot ].
	mode = 'diffSnapshots'
		ifTrue: [ cnf := SAConfig diffBased.
			cnf mainloop: SAMainLoopSnapshots ].
	mode = 'diffSnapshotsFast'
		ifTrue: [ cnf := SAConfig diffBased.
			cnf mainloop: SAMainLoopSnapshotsFast  ].
	mode = 'dspotFast'
		ifTrue: [ cnf := SAConfig dspotAllamps.
			timeBudget > 0 ifTrue: [ 
				cnf timeBudget: timeBudget * 60.
				cnf ranking: true. ].
			cnf mainloop: SAMainLoopSnapshotsFast  ].
	mode = 'diff'
		ifTrue: [ cnf := SAConfig diffBased.
			cnf mainloop: SAMainLoopDspot ].
	SmallAmp <~ ('started mode: ' , mode , ' for: ' , aTestClass name).
	self runSmallAmp: aTestClass config: cnf.
	SmallAmp <~ ('finished mode: ' , mode , ' for: ' , aTestClass name)
]

{ #category : #'as yet unclassified' }
SACommandLineHandler >> runSmallAmp: aTestClass config: cnf [
	Smalltalk os environment asDictionary
		at: #SMALLAMP_iteration
		ifPresent: [ :iter | cnf iterations: iter asInteger ].
	Smalltalk os environment asDictionary
		at: #SMALLAMP_maxInputs
		ifPresent: [ :maxInputs | cnf maxPop: maxInputs asInteger ].
	(SmallAmp initializeWith: cnf)
		testCase: aTestClass;
		amplifyEval
]
