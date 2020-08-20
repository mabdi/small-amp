Class {
	#name : #SACodeCoverageSelection,
	#superclass : #SAAbstractSelection,
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SACodeCoverageSelection >> analysisFor: testClasses targets: targetClasses ignore: aListOfMethods [
	^ SACoverageAnalyser new
		classes: targetClasses;
		testCases: testClasses;
		ignoreList: aListOfMethods;
		setNodes;
		runCoverage
]

{ #category : #enumerating }
SACodeCoverageSelection >> chooseBestFrom: theList notIncludedIn: result [
	"first select shortest methods
	Then, select minimum change,"

	| shortestLen shorts aList |
	aList := theList
		reject: [ :s | result anySatisfy: [ :s2 | s2 testMethod = s testMethod ] ].
	aList ifEmpty: [ ^ nil ].
	shortestLen := (aList collect: [ :s | s testMethod lines size ]) min.
	shorts := aList
		select: [ :s | s testMethod lines size = shortestLen ].
	^ (shorts
		sort: [ :a :b | 
			(a selector count: [ :x | x = $_ ])
				< (b selector count: [ :x | x = $_ ]) ]) first
]

{ #category : #cleanup }
SACodeCoverageSelection >> cleanUp: generatedClass [
	generatedClass testSelectors
		do: [ :sel | generatedClass removeSelector: sel ]
]

{ #category : #'as yet unclassified' }
SACodeCoverageSelection >> initialAnalysisFor: testClasses targets: targetClasses ignore: aListOfMethods [
	| analysis |
	analysis := self
		analysisFor: testClasses
		targets: targetClasses
		ignore: aListOfMethods.
	uncovered := analysis uncovered asSet.
	^ analysis
]

{ #category : #cleanup }
SACodeCoverageSelection >> runCoverage: aPopulation [
	| testClass  newTestClass pages |
	testClass := aPopulation atRandom testClass.
	newTestClass := nil.
	pages := self split: aPopulation page: 100.
	^ pages
		collect: [ :aPage | 
			newTestClass
				ifNil: [ newTestClass := SAASTHelper new
						buildTestClassWith: (aPopulation collect: [ :tcase | tcase testMethod ])
						using: testClass ]
				ifNotNil: [ :cls | 
					aPage
						do:
							[ :item | cls compile: item testMethod ] ].
			self runCoverageClass: newTestClass ]
		displayingProgress: 'Running Coverage'
]

{ #category : #cleanup }
SACodeCoverageSelection >> runCoverageClass: newTestClass [
	| analysis newUncovered wins |
	analysis := SACoverageAnalyser new
		testCases: {newTestClass};
		runFor: uncovered.
	newUncovered := analysis uncovered.
	wins := self allOpenedWindows.
	self cleanUp: newTestClass.
	self closeAllWindowsBut: wins.
	Stdio stdout
		nextPutAll: Time nowUTC print24;
		nextPutAll: String space;
		nextPutAll: 'Coverage ran: new uncovered ';
		nextPutAll: newUncovered size asString;
		lf;
		flush.
	^ analysis 
]

{ #category : #cleanup }
SACodeCoverageSelection >> select: aPopulation [
	| analysisList result newCovered newCovered_tmp |
	result := OrderedCollection new.
	analysisList := self runCoverage: aPopulation.
	uncovered := (analysisList flatCollect: #uncovered) asSet.
	newCovered_tmp := analysisList collect: #covered.
	newCovered := Dictionary new.
	(newCovered_tmp flatCollect: #keys)
		do: [ :k | 
			newCovered at: k put: Set new.
			newCovered_tmp
				do: [ :dic | dic at: k ifPresent: [ :x | (newCovered at: k) addAll: x ] ] ].
	result := newCovered
		collect: [ :item | 
			self
				chooseBestFrom:
					(aPopulation
						select: [ :p | (item collect: #selector) includes: p selector ])
				notIncludedIn: result ].
	^ result reject: #isNil
]
