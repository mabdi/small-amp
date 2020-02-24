Class {
	#name : #SAResultItem,
	#superclass : #Object,
	#instVars : [
		'failedSelectorInOriginal',
		'reducedVersions',
		'targetClasses',
		'testClass',
		'originalAnalysis',
		'logs'
	],
	#category : #'SmallAmp-Model'
}

{ #category : #adding }
SAResultItem >> failedSelectorInOriginal [
	^ failedSelectorInOriginal
]

{ #category : #adding }
SAResultItem >> failedSelectorInOriginal: aListOfFaileds [
	failedSelectorInOriginal := aListOfFaileds 
]

{ #category : #initialization }
SAResultItem >> initialize [ 
	logs := SALogger new
]

{ #category : #initialization }
SAResultItem >> logs [
	^ logs
]

{ #category : #'as yet unclassified' }
SAResultItem >> markDownOn: stream [
	stream
		nextPutAll: '|';
		nextPutAll: testClass name;
		nextPutAll: '|';
		nextPutAll: (', ' join: (targetClasses collect: #name));
		nextPutAll: '|';
		nextPutAll:
			(Duration seconds: ((self logs summary collect: #value) sum / 1000) asInteger)
				humanReadablePrintString;
		nextPutAll: '|'.
	stream nextPutAll: '#TestMethods: '.
	stream nextPutAll: testClass methods size asString.
	stream nextPutAll: '<br>'.
	stream nextPutAll: '#AllMutations: '.
	stream
		nextPutAll: originalAnalysis generalResult numberOfEvaluatedMutants asString.
	stream nextPutAll: '<br>'.
	stream nextPutAll: '#KilledMutants: '.
	stream
		nextPutAll:
			originalAnalysis generalResult numberOfKilledOrTerminatedMutants
				asString.
	stream nextPutAll: '<br>'.
	stream nextPutAll: 'Score: %'.
	stream
		nextPutAll: originalAnalysis generalResult mutationScore asString.
	stream nextPutAll: '|'.
	reducedVersions
		do: [ :rVer | 
			rVer markDownOn: stream.
			stream nextPutAll: '|' ]
]

{ #category : #'as yet unclassified' }
SAResultItem >> markDownTitleOn: stream [
	stream
		nextPutAll: '|';
		nextPutAll: 'TestCase';
		nextPutAll: '|';
		nextPutAll: 'TestTargets';
		nextPutAll: '|';
		nextPutAll: 'Running Time';
		nextPutAll: '|';
		nextPutAll: 'Originial';
		nextPutAll: '|'.
	reducedVersions
		do: [ :rVer | 
			stream
				nextPutAll: rVer presentationName;
				nextPutAll: '|';
				cr ].
	stream
		nextPutAll: '|';
		nextPutAll: '---';
		nextPutAll: '|';
		nextPutAll: '---';
		nextPutAll: '|';
		nextPutAll: '---';
		nextPutAll: '|';
		nextPutAll: '----';
		nextPutAll: '|'.
	reducedVersions
		do: [ :rVer | 
			stream
				nextPutAll: '----';
				nextPutAll: '|';
				cr ]
]

{ #category : #'as yet unclassified' }
SAResultItem >> mutalkRunOriginal [
	| analysis1 |
	analysis1 := MutationTestingAnalysis
		testCasesFrom: {testClass}
		mutating: targetClasses
		using: MutantOperator contents
		with:
			(IgnoreFailingTestsMethodsEvaluationStrategy
				newWith: self failedSelectorInOriginal)
		with: (SmallAmpMutationsGenerationStrategy new).
	analysis1 runSmallAmp.
	originalAnalysis := analysis1
]

{ #category : #accessing }
SAResultItem >> originalAnalysis [
	^ originalAnalysis
]

{ #category : #accessing }
SAResultItem >> originalAnalysis: anObject [
	originalAnalysis := anObject
]

{ #category : #accessing }
SAResultItem >> reducedVersions [
	^ reducedVersions
]

{ #category : #accessing }
SAResultItem >> reducedVersions: item [
	reducedVersions := item
]

{ #category : #accessing }
SAResultItem >> targetClasses [
	^ targetClasses
]

{ #category : #accessing }
SAResultItem >> targetClasses: anObject [
	targetClasses := anObject
]

{ #category : #accessing }
SAResultItem >> testClass [
	^ testClass
]

{ #category : #accessing }
SAResultItem >> testClass: anObject [
	testClass := anObject
]
