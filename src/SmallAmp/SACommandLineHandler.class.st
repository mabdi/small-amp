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
		ifTrue: [ self reloadSmallAmp ].
	(self hasOption: 'stat')
		ifTrue: [ self evalStats ].
	(self hasOption: 'amp')
		ifTrue: [ self evalAmp ].
	(self hasOption: 'clearTemp')
		ifTrue: [ self clearTempClasses ].
	self end
]

{ #category : #'as yet unclassified' }
SACommandLineHandler >> allClassesForRepo: repoName [
	(IceRepository registry detect: [ :r | r name = repoName ] ifFound: [ :r | ^ (r workingCopy packages select: [ :p | p isLoaded ])
		flatCollect: [ :p | p package asPackage definedClasses ] ] ifNone: [ self error: 'repo not installed. ' , repoName])
		
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
	testClass := self arguments
		detect: [ :arg | arg beginsWith: '--amp=' ]
		ifFound: [ :arg | arg allButFirst: '--amp=' size ].
	SmallAmp initializeDefault testCase: testClass ; amplifyEval
]

{ #category : #'as yet unclassified' }
SACommandLineHandler >> evalStats [
	| prefix |
	prefix := self arguments
		detect: [ :arg | arg beginsWith: '--stat=' ].
	prefix := prefix  allButFirst: '--stat=' size.
	self metricsEval: prefix
]

{ #category : #actions }
SACommandLineHandler >> metricsEval: repoName [
	| classes tests targetedTests testMethodTargeted stat testrun testsuite loc |
	classes := self allClassesForRepo: repoName.
	loc := (classes collect: #linesOfCode) sum.
	tests := classes select: #isTestCase.
	targetedTests := tests
		select: [ :s | s smallAmpTargetClasses isNotNil ].
	"targetedTests := targetedTests
		select: [ :ts | 
			| mr |
			[ mr := self runMutalk: ts.
			mr generalResult mutationScore < 100 ]
				on: Exception
				do: [ false ] ]."
	testsuite := TestSuite new.
	targetedTests do: [ :ts | testsuite addTests: ts buildSuite tests ].
	testrun := testsuite run.
	testMethodTargeted := testsuite tests.
	stat := {(#classes -> classes size).
	(#tests -> tests size).
	(#loc -> loc).
	(#targetedTests -> targetedTests size).
	(#targetedTestsMethods -> testMethodTargeted size).
	(#allGreen -> (testrun failureCount + testrun errorCount < 0)).
	(#testsFails -> testrun failureCount).
	(#testsErrors -> testrun errorCount).
	(#testsPasses -> testrun passedCount)} asString.
	(FileLocator imageDirectory / (repoName , '.stat')) writeStream
		nextPutAll: stat;
		lf;
		close.
	(FileLocator imageDirectory / 'todo.txt') writeStream
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
SACommandLineHandler >> reloadSmallAmp [
	IceRepository registry
		detect: [ :r | r name = 'small-amp' ]
		ifFound: [ :r | r pull ]
		ifNone: [ self exitFailure: 'repo not found.' ]
]

{ #category : #'as yet unclassified' }
SACommandLineHandler >> runMutalk: aTestClass [
	| analysis1 |
	analysis1 := MutationTestingAnalysis
		testCasesFrom: {aTestClass}
		mutating: aTestClass smallAmpTargetClasses 
		using: MutantOperator contents
		with: SortedTestsMethodsRunningMutantEvaluationStrategy new
		with: SmallAmpMutationsGenerationStrategy new.
	analysis1 run.
	^ analysis1
]
