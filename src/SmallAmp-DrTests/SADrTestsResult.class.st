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
SADrTestsResult >> aliveMutants [
	| subs |
	subs := smallAmpResult results values
		collect: [ :x | 
			DTTreeNode new
				name: x testClass name;
				subResults:
					{(DTTreeNode new
						name: 'Alive mutants in original:';
						subResults:
							(x originalAnalysis generalResult aliveMutants
								collect: #asResultForDrTest);
						yourself).
					(DTTreeNode new
						name: 'Killed mutants in amplified';
						subResults:
							((self filterJustKilledMutants: x reducedVersions first analysis generalResult killedMutants basedOn: x originalAnalysis generalResult killedMutants)
								collect: #asResultForDrTest);
						yourself)};
				yourself ].
	^ DTTreeNode new
		name: 'Mutants';
		subResults: subs;
		yourself
]

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
							((self
								filterJustAddedMethods: x reducedVersions first reducedClass
								basedOn: x testClass) collect: #asResultForDrTest);
						yourself)};
				yourself ].
	^ DTTreeNode new
		name: 'Amplified TestCase';
		subResults: subs;
		yourself
]

{ #category : #accessing }
SADrTestsResult >> buildTreeForUI [
	<dtSmallAmpResultTreeNamed: 'Output of SmallAmp' order: 1>
	^ DTTreeNode new
		subResults:
			{self amplifiedClasses.self mutationScores.
			self aliveMutants.
			self skippedTestMethods.
			
			self timeInformations}
]

{ #category : #'as yet unclassified' }
SADrTestsResult >> buildTreeInspectResult [
	<dtSmallAmpResultTreeNamed: 'Inspect the result' order: 2>
	self smallAmpResult ifNotNil: [ :a | a inspect ].
	^ DTTreeNode new subResults: {}
]

{ #category : #'as yet unclassified' }
SADrTestsResult >> filterJustAddedMethods: newClass basedOn: originalClass [
	^ newClass methods reject: [ :m | originalClass selectors includes: m selector ]
]

{ #category : #'as yet unclassified' }
SADrTestsResult >> filterJustKilledMutants: newKilledMutants basedOn: originalKilledMutants [
	^ newKilledMutants reject: [ :m | (originalKilledMutants collect: [ :x | x mutant modifiedSource ]) includes: m mutant modifiedSource  ]
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

{ #category : #accessing }
SADrTestsResult >> timeInformations [
	| subs |
	subs := smallAmpResult results values
		collect: [ :x | 
			| sums sum |
			sum := (x logs sums collect: #value) sum.
			sums := x logs sums
				collect: [ :s | 
					DTTreeNode new
						name:
							s key asString , ': % '
								, (100 * s value / sum printShowingDecimalPlaces: 2) , ' ('
								, (s value / 1000 printShowingDecimalPlaces: 3) , ' sec)';
						subResults: {};
						yourself ].
			DTTreeNode new
				name:
					x testClass name , ' (' , (sum / 1000 printShowingDecimalPlaces: 3)
						, ' sec)';
				subResults: sums;
				yourself ].
	^ DTTreeNode new
		name: 'Running time: ';
		subResults: subs;
		yourself
]
