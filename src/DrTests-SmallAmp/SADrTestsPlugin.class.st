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
	#category : #'DrTests-SmallAmp'
}

{ #category : #'api - accessing' }
SADrTestsPlugin class >> pluginName [
	^ 'Test Amplification'
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
			[ :p | p definedClasses select: [ :c | (c allSuperclasses includes: TestCase) and: [ self hasTestTarget: c ] ] ]
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
	|  result |
	result := self pluginResultClass new.
	self flag: #TODO.
	^ result
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

{ #category : #api }
SADrTestsPlugin >> startButtonHelp [
	^ 'Run test amplification in selected test classes' translated
]

{ #category : #api }
SADrTestsPlugin >> startButtonLabel [
	^ 'Run Amplification'
]
