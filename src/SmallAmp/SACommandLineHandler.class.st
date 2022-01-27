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
	#category : #'SmallAmp-Core'
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

	self activateHelp ifTrue: [ ^ self ].
	(self hasOption: 'stat') ifTrue: [ self evalStats ].
	(self hasOption: 'xinfo') ifTrue: [ self extraInformation ].
	(self hasOption: 'mode') ifTrue: [ self runInMode ].
	(self hasOption: 'resume') ifTrue: [ self resumeRunning ].
	(self hasOption: 'loadAndCommit') ifTrue: [ self loadAndCommit ].
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

	| prefix shred |
	prefix := self arguments detect: [ :arg | arg beginsWith: '--stat=' ].
	prefix := prefix allButFirst: '--stat=' size.
	self arguments
		detect: [ :arg | arg beginsWith: '--shred=' ]
		ifFound: [ :arg | shred := (arg allButFirst: '--shred=' size) asInteger ]
		ifNone: [ shred := 0 ].
	SAGenericMethods new metricsEval: prefix shred: shred
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
SACommandLineHandler >> getEnv: key required: isRequired [

	^ Smalltalk os environment asDictionary at: key ifAbsent: [ 
		  
			  SmallAmp <~ (key , ' missing').isRequired ifTrue: [ 
			  Smalltalk exitFailure ] ]
]

{ #category : #'as yet unclassified' }
SACommandLineHandler >> installTest: selector from: aClass repo: repo [

	| toCommit visitor diff test commitText |
	SmallAmp <~ ('Compiling: {1}>>{2} from: {3}' format: { 
			 aClass superclass name.
			 selector asString.
			 aClass name }).
	aClass superclass compile:
		(aClass lookupSelector: selector) sourceCode.
	test := aClass superclass >> selector.

	toCommit := OrderedCollection new.
	toCommit add: test.
	visitor := SANewChangesDiffVisitor new methodsToCommit: toCommit.
	diff := repo workingCopyDiff.
	diff accept: visitor.
	diff := diff copyWithOnly: visitor newTree.
	commitText := 'A new test method is added: ' , test name.
	commitText := test ast hasComments ifTrue: [ 
		              commitText := '{1}
{2}' format: { 
				                            commitText.
				                            test ast comments first contents } ].
	SmallAmp <~ 'Commiting test method'.
	repo commitChanges: diff withMessage: commitText
]

{ #category : #'as yet unclassified' }
SACommandLineHandler >> loadAndCommit [

	| gcnf gitClone all_st package repo repoName diff |
	gitClone := self getEnv: #GITHUB_WORKSPACE required: true.
	repoName := self getEnv: #reponame required: true.
	
	repo := IceRepository registry detect: [ :r | r name = repoName ].
	gcnf := repo getConfigurationGlobal: false.
	gcnf username: (repo getConfigurationGlobal: true) username.

	SmallAmp
	<~
		('Repo found. Loaded from: {1}, username: {2}, global: {3}' format:
			 { 
				 repo location asAbsolute pathString.
				 gcnf username.
				 (repo getConfigurationGlobal: true) username }).
	diff := repo workingCopyDiff.
	SmallAmp <~ ('Diff before import: ' , diff packages asString).

	all_st := FileLocator imageDirectory childrenMatching: '*.st'.
	SmallAmp <~ ('all_st: ' , (all_st collect: #asString)).
	all_st do: [ :a_st | a_st asFileReference fileIn ].

	SmallAmp <~ 'File in done'.
	(RPackageOrganizer default includesPackageNamed:
		 'SmallAmpFinalClasses') ifFalse: [ 
		SmallAmp <~ 'SmallAmpFinalClasses missing'.
		Smalltalk exitFailure ].

	package := RPackageOrganizer default packageNamed:
		           'SmallAmpFinalClasses'.
	package classes do: [ :aClass | 
		aClass testSelectors do: [ :selector | 
			self installTest: selector from: aClass repo: repo ] ].

	SmallAmp <~ 'Importing done'.
	Smalltalk snapshot: true andQuit: true
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
	mode = 'dspotFastRank'
		ifTrue: [ cnf := SAConfig dspotAllamps.
			timeBudget > 0 ifTrue: [ 
				cnf timeBudget: timeBudget * 60.
				cnf ranking: true. ].
			cnf mainloop: SAMainLoopSnapshotsFast  ].
	mode = 'dspotFast'
		ifTrue: [ cnf := SAConfig dspotAllamps.
			timeBudget > 0 ifTrue: [ 
				cnf timeBudget: timeBudget * 60.
				cnf ranking: false. ].
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
