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

{ #category : #testing }
SADrTestsPlugin class >> isAbstract [
	^ self = SADrTestsPlugin
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
SADrTestsPlugin >> itemsToBeAnalysedFor: packagesSelected [
	"This method returns the items to be analysed by the plugin.
	For most plugins it will be TestCases but some plugins will return other objects like comments."

	^ packagesSelected
		flatCollect: [ :p | 
			p definedClasses
				select: [ :c | 
					(c allSuperclasses includes: TestCase)
						and: [ c smallAmpTargetClasses isNotNil ] ] ]
]

{ #category : #'as yet unclassified' }
SADrTestsPlugin >> oldPragmaForResultTrees [
	"My subclasses implement this method to return the old pragma that was used to declare tree views.
	 I will be removed once the migration will be achieved.
	"
	^ #olddtSmallAmpResultTreeNamed:order:
]

{ #category : #api }
SADrTestsPlugin >> packagesAvailableForAnalysis [
	^ RPackage organizer packages
		select: [ :p | p definedClasses anySatisfy: [ :c | c isTestCase and: [ c smallAmpTargetClasses isNotNil  ] ] ]
]

{ #category : #accessing }
SADrTestsPlugin >> pragmaForResultTrees [
	^ #dtSmallAmpResultTreeNamed:order:
]

{ #category : #api }
SADrTestsPlugin >> resultButtonHelp [
	^ 'Browse the method selected in the results list.' translated
]

{ #category : #api }
SADrTestsPlugin >> runForConfiguration: aDTpluginConfiguration [
	| smallAmp smallAmpResult config result |
	config := self smallAmpDefaultConfig.
	smallAmp := SmallAmp initializeWith: config.
	aDTpluginConfiguration items
		do: [ :i | smallAmp testCase: i targets: i smallAmpTargetClasses ].
	smallAmpResult := smallAmp amplifyAll.
	result := self pluginResultClass new.
	result smallAmpResult: smallAmpResult.
	^ result
]

{ #category : #api }
SADrTestsPlugin >> secondListLabel [
	^ 'Test classes with targets'
]

{ #category : #'as yet unclassified' }
SADrTestsPlugin >> smallAmpDefaultConfig [
	| c |
	c := SAConfig default.
	^ c
]

{ #category : #api }
SADrTestsPlugin >> startButtonHelp [
	^ 'Run test amplification in selected test classes' translated
]

{ #category : #api }
SADrTestsPlugin >> startButtonLabel [
	^ 'Run Amplification'
]
