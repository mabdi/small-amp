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
	(self hasOption: 'useSnapshots')
		ifTrue: [  self useSnapshots ].
	(self hasOption: 'dspot')
		ifTrue: [  self dspot ].
	self end
]

{ #category : #'as yet unclassified' }
SACommandLineHandler >> dspot [
	| cmd className aTestClass |
	cmd := '--dspot='.
	self arguments
		detect: [ :arg | arg beginsWith: cmd ]
		ifFound: [ :arg | className := arg allButFirst: cmd size ].
	aTestClass := Smalltalk globals at: className asSymbol.
	SmallAmp <~ ('started #dspot: for ' , aTestClass name).
	self runSmallAmp: aTestClass mainLoop: SAMainLoopDspot.
	SmallAmp <~ ('finished #dspot: for ' , aTestClass name)
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
	SmallAmp metricsEval: prefix
]

{ #category : #accessing }
SACommandLineHandler >> extraInformation [
	| testName res resstr fileName |
	self arguments
		detect: [ :arg | arg beginsWith: '--xinfo=' ]
		ifFound: [ :arg | testName := arg allButFirst: '--xinfo=' size ].
	res := SmallAmp extraInformationFor: testName.
	resstr := STONJSON toStringPretty: res.
	fileName := testName , '.xjson'.
	(FileLocator imageDirectory / fileName) exists
		ifTrue: [ (FileLocator imageDirectory / fileName) delete ].
	(FileLocator imageDirectory / fileName) writeStream
		nextPutAll: resstr;
		close
]

{ #category : #'as yet unclassified' }
SACommandLineHandler >> runSmallAmp: aTestClass mainLoop: mode [
	| cnf |
	cnf := SAConfig default.
	Smalltalk os environment asDictionary
		at: #SMALLAMP_iteration
		ifPresent: [ :iter | cnf iterations: iter asInteger ].
	Smalltalk os environment asDictionary
		at: #SMALLAMP_maxInputs
		ifPresent: [ :maxInputs | cnf maxPop: maxInputs asInteger ].
	cnf mainloop: mode.
	(SmallAmp initializeWith: cnf)
		testCase: aTestClass;
		amplifyEval
]

{ #category : #'as yet unclassified' }
SACommandLineHandler >> useSnapshots [
	| cmd className aTestClass |
	cmd := '--useSnapshots='.
	self arguments
		detect: [ :arg | arg beginsWith: cmd ]
		ifFound: [ :arg | className := arg allButFirst: cmd size ].
	aTestClass := Smalltalk globals at: className asSymbol.
	SmallAmp <~ ('started #useSnapshots: for ' , aTestClass name).
	self runSmallAmp: aTestClass mainLoop: SAMainLoopSnapshots.
	SmallAmp <~ ('finished #useSnapshots: for ' , aTestClass name)
]
