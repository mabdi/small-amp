"
I am a copy of class DTTestCoverageResult. This comment is copied from there, and might not be entirely accurate

I build a tree with information: 
-percent of covered methods in the selected packages
-List of the uncovered methods
I am used in DrTestsUI to show the results in a orderly manner.
"
Class {
	#name : #SADrTestsResult,
	#superclass : #DTPluginResult,
	#instVars : [
		'smallAmpResult'
	],
	#category : #'SmallAmp-DrTests'
}

{ #category : #accessing }
SADrTestsResult >> amplifiedClasses [
	| subs |
	subs := smallAmpResult results values
		collect: [ :x | 
			DTTreeNode new
				name: x testClass name;
				subResults:
					{(DTTreeNode new
						name: 'Original (' , x testClass name , '):';
						subResults: (x testClass methods collect: #asResultForDrTest);
						yourself).
					(DTTreeNode new
						name: 'Amplified (' , x reducedVersions first reducedClass name , '):';
						subResults:
							(x reducedVersions first reducedClass methods
								collect: #asResultForDrTest);
						yourself)};
				yourself ].
			^(DTTreeNode new
				name: 'Amplified TestCase';
				subResults: subs;
				yourself)
]

{ #category : #accessing }
SADrTestsResult >> buildTreeForUI [
	<dtSmallAmpResultTreeNamed: 'Output of SmallAmp' order: 1>
	^ DTTreeNode new
		subResults:
			{self mutationScores.
			self amplifiedClasses}
]

{ #category : #'as yet unclassified' }
SADrTestsResult >> buildTreeInspectResult [
	<dtSmallAmpResultTreeNamed: 'Inspect the result' order: 2>
	self smallAmpResult ifNotNil: [ :a | a inspect ].
	^ DTTreeNode new subResults: {}
]

{ #category : #accessing }
SADrTestsResult >> mutationScores [
	| subs |
	subs := smallAmpResult results values
		collect: [ :x | 
			DTTreeNode new
				name: x testClass name;
				subResults:
					{(DTTreeNode new
						name:
							x testClass name , ': %'
								, x originalAnalysis generalResult mutationScore asString;
						subResults: {};
						yourself).
					(DTTreeNode new
						name:
							x reducedVersions first reducedClass name , ': %'
								, x reducedVersions first analysis generalResult mutationScore asString;
						subResults: {};
						yourself)};
				yourself ].
	^ DTTreeNode new
		name: 'Mutation scores';
		subResults: subs;
		yourself
]

{ #category : #accessing }
SADrTestsResult >> skippedTestMethods [
	| subs |
	subs := smallAmpResult results values
		collect: [ :x | 
			DTTreeNode new
				name: x testClass name;
				subResults:
					(x failedSelectorInOriginal asOrderedCollection
						collect: #asResultForDrTest);
				yourself ].
			^ DTTreeNode new
				name: 'Skipped test methods';
				subResults: subs;
				yourself
]

{ #category : #accessing }
SADrTestsResult >> smallAmpResult [
	^ smallAmpResult
]

{ #category : #accessing }
SADrTestsResult >> smallAmpResult: obj [
	smallAmpResult:= obj
]

{ #category : #accessing }
SADrTestsResult >> summarizeInfo [
	"Text showed in miniDrTests with info of the result "

	^ String
		streamContents: [ :s | 
			s
				<< (30 printShowingDecimalPlaces: 2);
				<< ' % Code Coverage';
				<< String cr;
				<< 'Uncovered methods:';
				<< String cr;
				<< self methodList size asString ]
]
