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

{ #category : #'as yet unclassified' }
SADrTestsResult >> buildTreeFileOut [
	<dtSmallAmpResultTreeNamed: 'File Out data' order: 3>
	self smallAmpResult ifNotNil: [ :result | result results keysAndValuesDo: [ :k :v | v saveResultToFileAs: k . v amplifiedClass fileOut  ] ].
	^ DTTreeNode new subResults: {}
]

{ #category : #accessing }
SADrTestsResult >> buildTreeForUI [
	<dtSmallAmpResultTreeNamed: 'Output of SmallAmp' order: 1>
	^ DTTreeNode new
		subResults:
			{smallAmpResult amplifiedClasses.
			smallAmpResult mutationScores.
			smallAmpResult aliveMutants.
			smallAmpResult skippedTestMethods.
			smallAmpResult notProfiledMethods.
			smallAmpResult timeInformations}
]

{ #category : #'as yet unclassified' }
SADrTestsResult >> buildTreeInspectResult [
	<dtSmallAmpResultTreeNamed: 'Inspect the result' order: 3>
	self smallAmpResult ifNotNil: [ :a | a inspect ].
	^ DTTreeNode new subResults: {}
]

{ #category : #'as yet unclassified' }
SADrTestsResult >> buildTreeMarkDownResult [
	<dtSmallAmpResultTreeNamed: 'Get the result in MarkDown' order: 2>
	self smallAmpResult ifNotNil: [ :a | a markDown inspect ].
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
   smallAmpResult results values ifEmpty: [ ^ Color named: 'gray'].
	^ getColor
		at:
			(smallAmpResult results values
				collect: [ :r | 
					getDegree
						value: r originalMutationScore
						value: r amplifiedMutationScore ]) min
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
				<< 'TODO' ]
]
