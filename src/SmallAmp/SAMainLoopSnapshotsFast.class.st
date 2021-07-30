Class {
	#name : #SAMainLoopSnapshotsFast,
	#superclass : #SAMainLoopDspot,
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SAMainLoopSnapshotsFast >> amplifyATestMethod: aTestMethod [
	self setTestMethodStarting: aTestMethod.
	self snapshotHere: aTestMethod.
	(self isRecoveredFromCrash: aTestMethod)
		ifTrue: [ ^ self ].
	super amplifyATestMethod: aTestMethod.
	
]

{ #category : #private }
SAMainLoopSnapshotsFast >> assertionAmplificationFor: aList [
	aList
		do: [ :tcase | self
				saveCrashEvidence:
					{(#testClass -> tcase testClass name).
					(#testMethod -> tcase testMethod)} asDictionary.
					.tcase assertionAmplifyBy: assertAmplifier ]
		
		displayingProgress: 'Assertion Amplification' , ' (' , aList size asString , ')'.
	^ aList reject: [ :tcase | tcase testMethod isNil ]
	
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshotsFast >> evidenceFile [
	^ FileLocator imageDirectory / '_smallamp_crash_evidence.json'
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshotsFast >> filenameForCurrentTest [
	^ FileLocator imageDirectory / '_smallamp_current_method_'
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshotsFast >> isRecoveredFromCrash: aTestMethod [
	| file current |
	file := self filenameForCurrentTest.
	current := file contents.
	current == aTestMethod selector
		ifTrue: [ ^ false ]
		ifFalse: [ SmallAmp <~ ('Recovered from a crash - skipping test method: '
				, aTestMethod selector).
			^ true ]
]

{ #category : #private }
SAMainLoopSnapshotsFast >> saveCrashEvidence: aDictionary [
	| str |
	str := STONJSON toString: aDictionary.
	self evidenceFile writeStream
		truncate;
		nextPutAll: str;
		close
]

{ #category : #actions }
SAMainLoopSnapshotsFast >> selectionFrom: aList [
	aList ifEmpty: [ ^ {} ].
	^ selection selectSnapshot: aList
]

{ #category : #initialization }
SAMainLoopSnapshotsFast >> setTestMethodStarting: aTestMethod [
	| file |
	file := self filenameForCurrentTest.
	file exists
		ifTrue: [ file delete ].
	self filenameForCurrentTest writeStream
		truncate;
		nextPutAll: aTestMethod selector;
		close
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshotsFast >> setupSelection [
	super setupSelection.
	selection
		onBeforeMutant: [ :mutant :index | 
			self
				saveCrashEvidence:
					{(#testClass -> testClass name).
					(#mutant -> mutant asDictionaryObject)} asDictionary ].
	selection onMutationEvaluation: [ 0 ]
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshotsFast >> snapshotHere: aTestMethod [
	self evidenceFile exists
		ifTrue: [ self evidenceFile delete ].
	Smalltalk snapshot: true andQuit: false
]
