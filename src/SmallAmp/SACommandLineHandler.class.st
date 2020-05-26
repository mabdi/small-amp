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
SACommandLineHandler >> metricsEval: aPrefix [
	| search packages classes testPackages tests targetedTests testMethodTargeted stat testrun testsuite loc |
	search := aPrefix asLowercase.
	packages := RPackage organizer packages
		select: [ :p | p name asLowercase includesSubstring: search ].
	classes := packages flatCollect: [ :p | p definedClasses ].
	loc := (classes collect: #linesOfCode) sum.
	testPackages := packages
		select: [ :p | p definedClasses anySatisfy: [ :c | c isTestCase ] ].
	tests := testPackages
		flatCollect:
			[ :p | p definedClasses select: [ :c | c allSuperclasses includes: TestCase ] ].
	testsuite := TestSuite new.
	tests do: [ :ts | testsuite addTests: ts buildSuite tests ].
	testrun := testsuite run.
	targetedTests := tests
		select: [ :s | s smallAmpTargetClasses isNotNil ].
	testMethodTargeted := targetedTests flatCollect: #allTestSelectors.
	stat := {{(#packages -> packages size).
	(#classes -> classes size).
	(#testPackages -> testPackages size).
	(#tests -> tests size).
	(#loc -> loc).
	(#targetedTests -> targetedTests size).
	(#targetedTestsMethods -> testMethodTargeted size).
	(#testsFails -> testrun failureCount).
	(#testsErrors -> testrun errorCount).
	(#testsPasses -> testrun passedCount)}} asString.
	(FileLocator imageDirectory / (search , '.stat')) writeStream
		nextPutAll: stat;
		lf;
		close.
	(FileLocator imageDirectory / 'todo.txt') writeStream
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
