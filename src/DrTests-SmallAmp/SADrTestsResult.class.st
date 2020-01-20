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
		'methodList',
		'percent'
	],
	#category : #'DrTests-SmallAmp'
}

{ #category : #accessing }
SADrTestsResult >> buildTreeForUI [
	<dtTestCoverageResultTreeNamed: 'List of uncovered methods' order: 1>
	^ DTTreeNode new
		subResults:
			{(DTTreeNode new
				name: (percent * 100 printShowingDecimalPlaces: 2) , ' % Code Coverage';
				subResults: {};
				yourself).
			(DTTreeNode new
				name: 'Uncovered methods';
				subResults: (self methodList collect: #asResultForDrTest);
				yourself)}
]

{ #category : #accessing }
SADrTestsResult >> methodList [
	^methodList
]

{ #category : #accessing }
SADrTestsResult >> methodList: aCollectionOfMethods [
	methodList := aCollectionOfMethods
]

{ #category : #accessing }
SADrTestsResult >> percent [
	^ percent
]

{ #category : #accessing }
SADrTestsResult >> percent: anObject [
	percent := anObject
]

{ #category : #accessing }
SADrTestsResult >> summarizeInfo [
	"Text showed in miniDrTests with info of the result "

	^ String
		streamContents: [ :s | 
			s
				<< (percent*100 printShowingDecimalPlaces: 2);
				<< ' % Code Coverage';
				<< String cr;
				<< 'Uncovered methods:';
				<< String cr;
				<< self methodList size asString ]
]
