"
Usage: smallamp [ --stat=prefix | --amp=testClass | --reload | --rejson=amplifiedClass | --noquit | --save ]
 	--stat=prefix               Calculates some statistics about packages with specified prefix
	--amp=testClass             runs smallamp on testClass
	--reload                    reload (git pull) small-amp repo
	--rejson=amplifiedClass     Regenerate json files for amplified class
	--clearTemp                 Clears temp package.
	--noquit                    Don't quite image after performing the operation
	--nosave                    Don't save image after opertation
	
Documentation:
Use this command to run smallamp.

Examples:
	# get the last updates in smallamp package
	pharo Pharo.image smallamp --reload
	# Stat for packages with names in pattern `smallamp*` 
	pharo Pharo.image smallamp --stat=SmallAmp
	# Run amplification for test class `SmallBankTest` 
	pharo Pharo.image smallamp --amp=SmallBankTest
	# Regenerate json file for the amplified test class `SmallBankTest123` 
	pharo Pharo.image smallamp --rejson=SmallBankTest123
	
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
	(self hasOption: 'reload')
		ifTrue: [ IceRepository pullRepoNamed: 'small-amp'.
			('Updated to: ' , (IceRepository latestCommitIdFor: 'small-amp'))
				traceCr.
			Smalltalk snapshot: true andQuit: true ].
	(self hasOption: 'stat')
		ifTrue: [ self evalStats ].
	(self hasOption: 'xinfo')
		ifTrue: [ self extraInformation ].
	(self hasOption: 'amp')
		ifTrue: [ self evalAmp ].
	(self hasOption: 'amptodo')
		ifTrue: [ self ampTodo ].
	(self hasOption: 'clearTemp')
		ifTrue: [ self clearTempClasses ].
	self end
]

{ #category : #'as yet unclassified' }
SACommandLineHandler >> allClassesForRepo: repoName [
	(IceRepository registry detect: [ :r | r name = repoName ] ifFound: [ :r | ^ (r workingCopy packages select: [ :p | p isLoaded ])
		flatCollect: [ :p | p package asPackage definedClasses ] ] ifNone: [ self error: 'repo not installed. ' , repoName])
		
]

{ #category : #'as yet unclassified' }
SACommandLineHandler >> ampTodo [
	| classes sa |
	classes := OrderedCollection new.
	self todoFile asFileReference
		readStream: [ :stream | classes add: stream nextLine asClass ].
	sa := SmallAmp initializeDefault.
	classes do: [ :cls | sa testCase: cls ].
	sa amplifyAll.
	Smalltalk snapshot: true andQuit: true
]

{ #category : #activation }
SACommandLineHandler >> clearTempClasses [
	SAASTHelper new clearTempClasses 
]

{ #category : #accessing }
SACommandLineHandler >> end [
	| noquit nosave |
	noquit := self commandLine hasOption: 'noquit'.
	nosave := (self commandLine hasOption: 'nosave').
	nosave ifFalse: [ Smalltalk snapshot: true andQuit: noquit not ].
	noquit
		ifFalse: [ self exitSuccess ]
]

{ #category : #'as yet unclassified' }
SACommandLineHandler >> evalAmp [
	| testClass |
	self arguments
		detect: [ :arg | arg beginsWith: '--amp=' ]
		ifFound: [ :arg | testClass := (arg allButFirst: '--amp=' size) asClass ].
	SmallAmp initializeDefault
		testCase: testClass;
		amplifyEval.
	Smalltalk snapshot: false andQuit: true.
]

{ #category : #'as yet unclassified' }
SACommandLineHandler >> evalStats [
	| prefix |
	prefix := self arguments
		detect: [ :arg | arg beginsWith: '--stat=' ].
	prefix := prefix  allButFirst: '--stat=' size.
	self metricsEval: prefix
]

{ #category : #accessing }
SACommandLineHandler >> extraInformation [
	| testName res resstr fileName |
	self arguments
		detect: [ :arg | arg beginsWith: '--xinfo=' ]
		ifFound: [ :arg | testName :=  arg allButFirst: '--xinfo=' size ].
	res := self extraInformationFor: testName.
	resstr := STONJSON toStringPretty: res.
	fileName := testName , '.xjson'.
	(FileLocator imageDirectory / fileName) exists
		ifTrue: [ (FileLocator imageDirectory / fileName) delete ].
	(FileLocator imageDirectory / fileName) writeStream
		nextPutAll: resstr;
		close
]

{ #category : #accessing }
SACommandLineHandler >> extraInformationFor: amplified [
	| json result targetClasses testClass amplifiedClass amplifiedCoverage originalCoverage |
	result := Dictionary new.
	json := STONJSON
		fromString:
			(FileLocator imageDirectory / (amplified , '.json')) asFileReference
				contents.
	targetClasses := (json at: #targetClasses)
		collect: [ :c | self class environment at: c asSymbol ].
	testClass := self class environment at: (json at: #testCase) asSymbol.
	self class environment
		at: (json at: #amplifiedClass) asSymbol
		ifPresent: [ :x | amplifiedClass := x ]
		ifAbsent: [ (FileLocator imageDirectory / ((json at: #amplifiedClass) , '.st'))
				asFileReference fileIn.
			amplifiedClass := self class environment
				at: (json at: #amplifiedClass) asSymbol ].
	amplifiedCoverage := SACoverageAnalyser new
		classes: targetClasses;
		testCases: {amplifiedClass};
		run.
	originalCoverage := SACoverageAnalyser new
		classes: targetClasses;
		testCases: {testClass};
		run.
	('Processing ', amplified) traceCr.
	self
		safeFail: [ SAReceiverTypeProfiler directCallsFor: testClass ]
		key: #directTestingOriginal
		addTo: result.
	self
		safeFail: [ ((targetClasses
				collect: [ :cls | (SACodeChurnAnalyser new codeChurnForClass: cls) asNumber ])
				inject: 0
				into: [ :accum :each | accum + each ])
				printShowingDecimalPlaces: 2 ]
		key: #targetChurn
		addTo: result.
	self
		safeFail: [ (SACodeChurnAnalyser new codeChurnForClass: testClass)
				printShowingDecimalPlaces: 2 ]
		key: #testChurn
		addTo: result.
	self
		safeFail: [ amplifiedCoverage methodsCoverage ]
		key: #amplifiedCoverageMethods
		addTo: result.
	self
		safeFail: [ amplifiedCoverage branchesCoverage ]
		key: #amplifiedCoverageBranches
		addTo: result.
	self
		safeFail: [ amplifiedCoverage statementsCoverage ]
		key: #amplifiedCoverageStatementes
		addTo: result.
	self
		safeFail: [ originalCoverage methodsCoverage ]
		key: #originalCoverageMethods
		addTo: result.
	self
		safeFail: [ originalCoverage branchesCoverage ]
		key: #originalCoverageBranches
		addTo: result.
	self
		safeFail: [ originalCoverage statementsCoverage ]
		key: #originalCoverageStatementes
		addTo: result.
	self
		safeFail: [ SATestAssertionDensity
				dencityFor: (testClass methods select: #isTestMethod) ]
		key: #assertionDensityOriginal
		addTo: result.
	self
		safeFail: [ SATestAssertionDensity
				dencityFor:
					(amplifiedClass methods
						select: [ :z | z hasPragmaNamed: SAASTHelper new defaultPragma ]) ]
		key: #assertionDensityAmplified
		addTo: result.
	^ result
]

{ #category : #actions }
SACommandLineHandler >> metricsEval: repoName [
	| classes tests targetedTests testMethodTargeted stat testrun testsuite loc commitId |
	classes := self allClassesForRepo: repoName.
	commitId := IceRepository latestCommitIdFor: repoName.
	loc := (classes collect: #linesOfCode) sum.
	tests := classes select: #isTestCase.
	targetedTests := tests
		select: [ :s | s smallAmpTargetClasses isNotNil ].
	testsuite := TestSuite new.
	targetedTests do: [ :ts | testsuite addTests: ts buildSuite tests ].
	testrun := testsuite run.
	testMethodTargeted := testsuite tests.
	stat := {(#classes -> classes size).
	(#tests -> tests size).
	(#loc -> loc).
	(#commitId -> commitId).
	(#targetedTests -> targetedTests size).
	(#targetedTestsMethods -> testMethodTargeted size).
	(#allGreen -> (testrun failureCount + testrun errorCount = 0)).
	(#testsFails -> testrun failureCount).
	(#testsErrors -> testrun errorCount).
	(#testsPasses -> testrun passedCount)} asString.
	(FileLocator imageDirectory / (repoName , '.stat')) writeStream
		nextPutAll: stat;
		lf;
		close.
	(FileLocator imageDirectory / self todoFile) writeStream
		nextPutAll: (Character lf join: targetedTests);
		lf;
		close.
	(FileLocator imageDirectory / 'allTests.txt') writeStream
		nextPutAll: (Character lf join: targetedTests);
		lf;
		close.
	^ stat
]

{ #category : #'as yet unclassified' }
SACommandLineHandler >> safeFail: block key: aKey addTo: aDictionary [
	| theValue |
	theValue := block
		on: Error
		do: [ :x | 
			Stdio stdout
				nextPutAll: Time nowUTC print24;
				nextPutAll: String space;
				nextPutAll: x class asString;
				nextPutAll: ': ';
				nextPutAll: x asString;
				nextPutAll: '-';
				nextPutAll: x messageText;
				lf;
				flush.
			'N/A' ].
	aDictionary at: aKey put: theValue
]

{ #category : #'as yet unclassified' }
SACommandLineHandler >> todoFile [
	^ 'todo.txt'
]
