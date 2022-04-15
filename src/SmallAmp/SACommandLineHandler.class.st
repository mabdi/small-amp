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
	#instVars : [
		'aTestClass'
	],
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
	(self hasOption: 'loadAndCommit') ifTrue: [ ^ self loadAndCommit ].
	(self hasOption: 'dashboardOutPut') ifTrue: [ ^ self dashboardOutPut ].
	self end
]

{ #category : #compiling }
SACommandLineHandler >> compileFinalMethod: aMethodAST in: aClass [

	| tree id |
	tree := aMethodAST copy.
	id := tree selector asString allButFirst: 'test' size.
	(tree pragmas anySatisfy: [ :pragma | 
		 pragma selector = SAGenericMethods defaultPragma ]) ifTrue: [ 
		tree pragmas: (tree pragmas reject: [ :pragma | 
				 pragma selector = SAGenericMethods defaultPragma ]) ].
	tree addPragma: (RBPragmaNode
			 selector: self class defaultPragmaWithId
			 arguments: { (RBLiteralValueNode value: id) }).
	aClass compile: tree formattedCode
]

{ #category : #'as yet unclassified' }
SACommandLineHandler >> dashboardOutPut [

	| root repo repoName commitTo |
	repoName := self getEnv: #reponame required: true.

	repo := IceRepository registry detect: [ :r | r name = repoName ].
	root := repo subdirectory.
	commitTo := Smalltalk os environment asDictionary
		            at: #GITHUB_SHA
		            ifAbsent: [ 'GITHUB_SHA not found' ].

	SASmallAmpDashboardJSONExporter new
		saveTo: '__smallamp_dashboard_export.json';
		commitHash: commitTo;
		stfilesSaveTo: FileLocator imageDirectory ;
		root: root;
		exportAll.
	SmallAmp <~ 'Exporting done'.
	Smalltalk snapshot: true andQuit: true
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

	| prefix shred seed commitFrom |
	prefix := self arguments detect: [ :arg | arg beginsWith: '--stat=' ].
	prefix := prefix allButFirst: '--stat=' size.
	self arguments
		detect: [ :arg | arg beginsWith: '--shred=' ]
		ifFound: [ :arg | 
		shred := (arg allButFirst: '--shred=' size) asInteger ]
		ifNone: [ shred := 0 ].
	seed := self getEnv: #SmallAmp_ShredSeed required: false.
	commitFrom := self getEnv: #SmallAmp_CommitFrom required: false.
	commitFrom ifNotNil: [commitFrom ifEmpty: [ commitFrom  := nil ]].
	seed := seed ifNil: [ 10 ] ifNotNil: [ seed asInteger ].
	SAGenericMethods new
		metricsEval: prefix
		shred: shred
		seed: seed
		from: commitFrom
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
		  SmallAmp <~ (key , ' missing').
		  isRequired ifTrue: [ Smalltalk exitFailure ].nil ]
]

{ #category : #'as yet unclassified' }
SACommandLineHandler >> installTest: orig_selector from: aClass repo: repo [

	| selector toCommit visitor diff test commitText ast |
	SmallAmp <~ ('Compiling: {1}>>{2} from: {3}' format: { 
			 aClass superclass name.
			 orig_selector asString.
			 aClass name }).
	selector := orig_selector.
	self compileFinalMethod: (aClass lookupSelector: selector) ast
				in: aClass superclass.
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
	commitText ifNil: [ 
		SmallAmp <~ 'commit msg is nil'.

		commitText := 'SmallAmp introduces ' , test name ].
	repo workingCopy
		commitChanges: diff
		withMessage: commitText
		force: true
]

{ #category : #'as yet unclassified' }
SACommandLineHandler >> loadAndCommit [

	| gcnf gitClone all_st package repo repoName diff jsons theJson |
	gitClone := self getEnv: #GITHUB_WORKSPACE required: true.
	repoName := self getEnv: #reponame required: true.
	SAGenericMethods new contextInit.

	repo := IceRepository registry detect: [ :r | r name = repoName ].
	gcnf := repo getConfigurationGlobal: false.

	SmallAmp
	<~
		('Repo found. Loaded from: {1}, username: {2}, email: {3}' format:
			 { 
				 repo location asAbsolute pathString.
				 gcnf username.
				 gcnf email }).
	diff := repo workingCopyDiff.
	SmallAmp <~ ('Diff before import: ' , diff packages asString).

	jsons := FileLocator imageDirectory childrenMatching: '*.json'.
	SmallAmp <~ ('all_jsons: ' , (jsons collect: #asString) asString).
	jsons ifEmpty: [ 
	SmallAmp <~ 'Nothing to import. Exiting.'.
	Smalltalk snapshot: true andQuit: true ].
	jsons do: [ :aJson | 
		aJson asFileReference readStreamDo: [ :readStream | 
			theJson := STONJSON fromStream: readStream ].
		(theJson includesKey: #amplifiedClass)
			ifTrue: [ 
				(FileLocator imageDirectory
				 / ((theJson at: #amplifiedClass) , '.st')) asFileReference fileIn ]
			ifFalse: [ 
				SmallAmp
				<~
				('The key #amplifiedClass not found. Skipping ' , aJson asString) ] ].

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

{ #category : #modes }
SACommandLineHandler >> mode_diff [

	| cnf |
	cnf := SAConfig diffBased.
	cnf mainloop: SAMainLoopDspot.
	self runSmallAmpConfig: cnf
]

{ #category : #modes }
SACommandLineHandler >> mode_diffSnapshotsFast [

	| cnf |
	cnf := SAConfig diffBased.
	cnf mainloop: SAMainLoopSnapshotsFast.
	self runSmallAmpConfig: cnf
]

{ #category : #modes }
SACommandLineHandler >> mode_dspot [

	| cnf |
	cnf := SAConfig dspotAllamps.
	cnf mainloop: SAMainLoopDspot.
	self runSmallAmpConfig: cnf
]

{ #category : #modes }
SACommandLineHandler >> mode_dspotFast [

	| cnf timeBudget cmd |
	cmd := '--timeBudget='.
	self arguments
		detect: [ :arg | arg beginsWith: cmd ]
		ifFound: [ :arg | 
		timeBudget := (arg allButFirst: cmd size) asInteger ]
		ifNone: [ timeBudget := 0 ].

	cnf := SAConfig dspotAllamps.
	timeBudget > 0 ifTrue: [ 
		cnf timeBudget: timeBudget * 60.
		cnf ranking: false ].
	cnf mainloop: SAMainLoopSnapshotsFast.
	self runSmallAmpConfig: cnf
]

{ #category : #modes }
SACommandLineHandler >> mode_dspotFastRank [

	| cnf timeBudget cmd |
	cmd := '--timeBudget='.
	self arguments
		detect: [ :arg | arg beginsWith: cmd ]
		ifFound: [ :arg | 
		timeBudget := (arg allButFirst: cmd size) asInteger ]
		ifNone: [ timeBudget := 0 ].

	cnf := SAConfig dspotAllamps.
	timeBudget > 0 ifTrue: [ 
		cnf timeBudget: timeBudget * 60.
		cnf ranking: true ].
	cnf mainloop: SAMainLoopSnapshotsFast.
	self runSmallAmpConfig: cnf
]

{ #category : #modes }
SACommandLineHandler >> mode_fseNone [

	| cnf timeBudget cmd |
	cmd := '--timeBudget='.
	self arguments
		detect: [ :arg | arg beginsWith: cmd ]
		ifFound: [ :arg | 
		timeBudget := (arg allButFirst: cmd size) asInteger ]
		ifNone: [ timeBudget := 0 ].

	cnf := SAConfig dspotOldamps.
	cnf mutalkUseOriginalOperators: true.
	timeBudget > 0 ifTrue: [ 
		cnf timeBudget: timeBudget * 60.
		cnf ranking: false ].
	cnf mainloop: SAMainLoopSnapshotsFast.
	self runSmallAmpConfig: cnf
]

{ #category : #modes }
SACommandLineHandler >> mode_fseRank [

	| cnf timeBudget cmd |
	cmd := '--timeBudget='.
	self arguments
		detect: [ :arg | arg beginsWith: cmd ]
		ifFound: [ :arg | 
		timeBudget := (arg allButFirst: cmd size) asInteger ]
		ifNone: [ timeBudget := 0 ].

	cnf := SAConfig dspotOldamps.
	cnf mutalkUseOriginalOperators: true.
	timeBudget > 0 ifTrue: [ 
		cnf timeBudget: timeBudget * 60.
		cnf ranking: true ].
	cnf mainloop: SAMainLoopSnapshotsFast.
	self runSmallAmpConfig: cnf
]

{ #category : #'as yet unclassified' }
SACommandLineHandler >> resumeRunning [
	Semaphore new wait
]

{ #category : #'as yet unclassified' }
SACommandLineHandler >> runInMode [

	| cmd timeBudget testClass mode |
	cmd := '--testClass='.
	self arguments
		detect: [ :arg | arg beginsWith: cmd ]
		ifFound: [ :arg | testClass := arg allButFirst: cmd size ]
		ifNone: [ 
			SmallAmp <~ '--testClass=TestClassName is required'.
			^ self ].
	cmd := '--timeBudget='.
	self arguments
		detect: [ :arg | arg beginsWith: cmd ]
		ifFound: [ :arg | 
		timeBudget := (arg allButFirst: cmd size) asInteger ]
		ifNone: [ timeBudget := 0 ].
	cmd := '--mode='.
	self arguments
		detect: [ :arg | arg beginsWith: cmd ]
		ifFound: [ :arg | mode := arg allButFirst: cmd size ].
	aTestClass := Smalltalk globals at: testClass asSymbol.
	SmallAmp <~ ('started mode: ' , mode , ' for: ' , aTestClass name).
	mode = 'dspot' ifTrue: [ self mode_dspot ].
	mode = 'diffSnapshotsFast' ifTrue: [ self mode_diffSnapshotsFast ].
	mode = 'dspotFastRank' ifTrue: [ self mode_dspotFastRank ].
	mode = 'dspotFast' ifTrue: [ self mode_dspotFast ].
	mode = 'diff' ifTrue: [ self mode_diff ].

	mode = 'fseRank' ifTrue: [ self mode_fseRank ].
	mode = 'fseNone' ifTrue: [ self mode_fseNone ].

	SmallAmp <~ ('finished mode: ' , mode , ' for: ' , aTestClass name)
]

{ #category : #'as yet unclassified' }
SACommandLineHandler >> runSmallAmpConfig: cnf [

	Smalltalk os environment asDictionary
		at: #SMALLAMP_iteration
		ifPresent: [ :iter | cnf iterations: iter asInteger ].
	Smalltalk os environment asDictionary
		at: #SMALLAMP_maxInputs
		ifPresent: [ :maxInputs | cnf maxPop: maxInputs asInteger ].
	Smalltalk os environment asDictionary
		at: #SMALLAMP_PORTION
		ifPresent: [ :envVal | SmallAmp <~ ('config ampNamesSuffix: ' , envVal).
		.
			cnf ampNamesSuffix: envVal ].
	(SmallAmp initializeWith: cnf)
		testCase: aTestClass;
		amplifyEval
]
