Class {
	#name : #SAMainLoopSnapshotsFast,
	#superclass : #SAMainLoopDspot,
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SAMainLoopSnapshotsFast >> amplifyATestMethod: aTestMethod [
	(self setTestMethodStarting: aTestMethod).
		
	self snapshotHere: aTestMethod.
	(self isRecoveredFromCrash: aTestMethod)
		ifTrue: [ ^ self ].
	super amplifyATestMethod: aTestMethod.
	(self setTestMethodFinished: aTestMethod)
		
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
SAMainLoopSnapshotsFast >> eventFile [
	^ FileLocator imageDirectory / '_smallamp_last_event.json'
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshotsFast >> evidenceFile [
	^ FileLocator imageDirectory / '_smallamp_crash_evidence.json'
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshotsFast >> isEventPresent: anEvent [
	^ self eventFile exists
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshotsFast >> isRecoveredFromCrash: aTestMethod [
	| file json record |
	file := self methods_state_file.
	json := STONJSON fromStream: file readStream.
	record := json at: aTestMethod selector.
	record == 'starting'
		ifFalse: [ SmallAmp <~ 'skipping test method: ' , aTestMethod selector
				, ' reason: ' , record.
			^ true ]
		ifTrue: [ ^ false ]
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshotsFast >> methods_state_file [
	^ FileLocator imageDirectory / '_smallamp_methods_state.json'
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshotsFast >> resetCurrentState [
	self stateFile exists
		ifTrue: [ self stateFile delete ]
]

{ #category : #private }
SAMainLoopSnapshotsFast >> restoreState [
	self stateFile exists
		ifFalse: [ ^ nil ].
	^ FLMaterializer materializeFromFileNamed: self stateFile basename
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

{ #category : #'as yet unclassified' }
SAMainLoopSnapshotsFast >> saveEvent: anEvent [
	| str |
	str := STONJSON toString: anEvent.
	(self eventFile) writeStream
		truncate;
		nextPutAll: str;
		close
]

{ #category : #private }
SAMainLoopSnapshotsFast >> saveTheState: anState [
	FLSerializer serialize: anState toFileNamed: self stateFile basename
]

{ #category : #actions }
SAMainLoopSnapshotsFast >> selectionFrom: aList [
	aList ifEmpty: [ ^ {} ].
	^ selection selectSnapshot: aList
]

{ #category : #initialization }
SAMainLoopSnapshotsFast >> setTestMethod: aTestMethod status: anStatus [
	| file str json |
	file := self methods_state_file.
	json := file exists
		ifTrue: [ STONJSON fromStream: file readStream ]
		ifFalse: [ Dictionary new ].
	json at: '_current_' put: aTestMethod selector.
	json at: aTestMethod selector put: anStatus.
	str := STONJSON toString: json.
	self methods_state_file writeStream
		truncate;
		nextPutAll: str;
		close
]

{ #category : #initialization }
SAMainLoopSnapshotsFast >> setTestMethodFinished: aTestMethod [
	self setTestMethod: aTestMethod status: 'success'
]

{ #category : #initialization }
SAMainLoopSnapshotsFast >> setTestMethodStarting: aTestMethod [
	self setTestMethod: aTestMethod status: 'starting'
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
SAMainLoopSnapshotsFast >> snapshot: anEvent [
	anEvent at: #testClass put: testClass name.
	self saveEvent: anEvent.
	Smalltalk snapshot: true andQuit: false.
	^ self isEventPresent: anEvent
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshotsFast >> snapshotHere: aTestMethod [
	self evidenceFile exists
		ifTrue: [ self evidenceFile delete ].
	Smalltalk snapshot: true andQuit: false
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshotsFast >> stateFile [
	^ FileLocator imageDirectory / '_smallamp_last_state.fl'
]
