"
I am a copy of class DTTestCoverage. This comment is copied from there, and might not be entirely accurate

I am a DrTestPlugin.
I show the percentage of covered methods with tests and show the list of the uncovered methods.
"
Class {
	#name : #SADrTestsPlugin,
	#superclass : #DrTestsPlugin,
	#instVars : [
		'methods',
		'testClasses',
		'link'
	],
	#category : #'SmallAmp-DrTests'
}

{ #category : #'api - accessing' }
SADrTestsPlugin class >> pluginName [
	^ 'Test Amplification (SmallAmp)'
]

{ #category : #'api - accessing' }
SADrTestsPlugin class >> pluginResultClass [
	^ DTTestCoverageResult
]

{ #category : #'api - accessing' }
SADrTestsPlugin class >> weight [
	^ 3
]

{ #category : #api }
SADrTestsPlugin >> allowMiniDrTests [
	^false
]

{ #category : #api }
SADrTestsPlugin >> allowMultipleSelectionInSecondList [
	^ true
]

{ #category : #api }
SADrTestsPlugin >> firstListLabel [
	^ 'Test Packages'
]

{ #category : #api }
SADrTestsPlugin >> hasTestTarget: testClass [
]

{ #category : #api }
SADrTestsPlugin >> itemsToBeAnalysedFor: packagesSelected [
	"This method returns the items to be analysed by the plugin.
	For most plugins it will be TestCases but some plugins will return other objects like comments."

	^ packagesSelected
		flatCollect:
			[ :p | p definedClasses select: [ :c | (c allSuperclasses includes: TestCase) and: [ (SADrTestsRunInput from: c) testTarget isNotNil ] ] ]
]

{ #category : #'as yet unclassified' }
SADrTestsPlugin >> makeTreeResult: smallAmpResult [
	| result |
	result := self pluginResultClass new.
	self halt.
	^ result
]

{ #category : #accessing }
SADrTestsPlugin >> pragmaForResultTrees [
	^ #'dtTestCoverageResultTreeNamed:order:'
]

{ #category : #api }
SADrTestsPlugin >> resultButtonHelp [
	^ 'Browse the method selected in the results list.' translated
]

{ #category : #api }
SADrTestsPlugin >> runForConfiguration: aDTpluginConfiguration [
	| result smallAmp smallAmpResult |
	
	smallAmp := SmallAmp initializeWith: self smallAmpDefaultConfig.
	aDTpluginConfiguration items
		do:
			[ :i | smallAmp testCase: i targets: (SADrTestsRunInput from: i) testTarget ].
	smallAmpResult := smallAmp amplifyAll.
	^ self makeTreeResult: smallAmpResult .
]

{ #category : #api }
SADrTestsPlugin >> secondListLabel [
	^ 'Test classes with targets'
]

{ #category : #api }
SADrTestsPlugin >> setSelectionModeOfItemsList: aListPresenter [
	aListPresenter
		beSingleSelection;
		unselectAll
]

{ #category : #'as yet unclassified' }
SADrTestsPlugin >> smallAmpDefaultConfig [
	^ SAConfig new
		iterations: 3;
		assertionAmplifiers: {SADefaultAssertionAmplifier};
		inputAmplifiers:
			{SALiteralInputAmplifier.
			SAAddInputAmplifier};
		profiler: SAProxyProfiler new;
		selections: {SAMutationCoverageSelection};
		oracleReducions: {SAMuTalkFirstFailOracleReduction};
		"debug: true;"
			yourself.
]

{ #category : #api }
SADrTestsPlugin >> startButtonHelp [
	^ 'Run test amplification in selected test classes' translated
]

{ #category : #api }
SADrTestsPlugin >> startButtonLabel [
	^ 'Run Amplification'
]
