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
		'smallAmpResult',
		'runConfig'
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
							((self
								filterJustKilledMutants: x reducedVersion analysis generalResult killedMutants
								basedOn: x originalAnalysis generalResult killedMutants)
								collect: #asResultForDrTest);
						yourself).
					(DTTreeNode new
						name: 'Still alive mutants in amplified';
						subResults:
							(x reducedVersion analysis generalResult aliveMutants
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
						name: 'Amplified (' , x reducedVersion reducedClass name , '):';
						subResults:
							(x reducedVersion reducedClass methods
								select: [ :z | z hasPragmaNamed: SAASTHelper new defaultPragma ]
								thenCollect: #asResultForDrTest);
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
			{self amplifiedClasses.
			self mutationScores.
			self aliveMutants.
			self skippedTestMethods.
			self notProfiledMethods.
			self timeInformations}
]

{ #category : #'as yet unclassified' }
SADrTestsResult >> buildTreeInspectResult [
	<dtSmallAmpResultTreeNamed: 'Inspect the result' order: 2>
	self smallAmpResult ifNotNil: [ :a | a inspect ].
	^ DTTreeNode new subResults: {}
]

{ #category : #accessing }
SADrTestsResult >> color [
	| getColor getDegree |
	getColor := {(0 -> (Color named: 'red')).
	(1 -> (Color named: 'gray')).
	(2 -> (Color named: 'yellow')).
	(3 -> (Color named: 'lightGreen')).
	(4 -> (Color named: 'green'))} asDictionary.
	getDegree := [ :score_old :score_new | 
	| res |
	res := nil.
	score_new - score_old < 10
		ifTrue: [ res := 3 ].
	score_new - score_old >= 10
		ifTrue: [ res := 4 ].
	score_new - score_old = 0
		ifTrue: [ res := 2 ].
	
	score_new = 0
		ifTrue: [ res := 0 ].
	res ifNil: [ res := 1 ].
	res ].
	^ getColor
		at:
			(smallAmpResult results values
				collect: [ :r | 
					getDegree
						value: r originalAnalysis generalResult mutationScore
						value: r reducedVersion analysis generalResult mutationScore ])
				min
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
							'Original: ' , x testClass name , ': %'
								, x originalAnalysis generalResult mutationScore asString;
						subResults: {};
						yourself).
					(DTTreeNode new
						name:
							'Amplified: ', x reducedVersion reducedClass name , ': %'
								, x reducedVersion analysis generalResult mutationScore asString;
						subResults: {};
						yourself)};
				yourself ].
	^ DTTreeNode new
		name: 'Mutation scores';
		subResults: subs;
		yourself
]

{ #category : #accessing }
SADrTestsResult >> notProfiledMethods [
	| subs keys |
	
	subs := smallAmpResult results values
		collect: [ :x | 
			keys := runConfig profiler profile keys
				select:
					[ :p | x targetClasses anySatisfy: [ :t | p beginsWith: '#' , t name ] ].
			DTTreeNode new
				name: x testClass name;
				subResults:
					((x targetClasses
						flatCollect: [ :c | 
							(c methods select: [ :m | m selector includesSubstring: ':' ])
								reject: [ :m | 
									keys
										anySatisfy: [ :k | k beginsWith: '#' , c name , '#' , m selector ] ] ])
						collect: #asResultForDrTest);
				yourself ].
	^ DTTreeNode new
		name: 'Methods failed to be profiled:';
		subResults: subs;
		yourself
]

{ #category : #accessing }
SADrTestsResult >> runConfig [ ^ runConfig
]

{ #category : #accessing }
SADrTestsResult >> runConfig: config [
	runConfig := config
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
			sum := (x logs summary collect: #value) sum.
			sums := x logs summary
				collect: [ :s | 
					DTTreeNode new
						name:
							s key asString , ': % '
								, (100 * s value / sum printShowingDecimalPlaces: 2) , ' ('
								, (Duration milliSeconds: s value) humanReadablePrintString
								, ')';
						subResults: {};
						yourself ].
			DTTreeNode new
				name:
					x testClass name , ' (' , (Duration milliSeconds: sum) humanReadablePrintString 
						, ')';
				subResults: sums;
				yourself ].
	^ DTTreeNode new
		name: 'Running time: ';
		subResults: subs;
		yourself
]
