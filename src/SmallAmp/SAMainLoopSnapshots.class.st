Class {
	#name : #SAMainLoopSnapshots,
	#superclass : #SAMainLoopDspot,
	#category : #'SmallAmp-Core'
}

{ #category : #private }
SAMainLoopSnapshots >> assertionAmplificationFor: aListInput [
	| toSkip aList |
	self careTimeBudget ifFalse: [ ^ {  } ].
	aList := aListInput.
	toSkip := 0.
	self snapshotPoint: #assertion_amplification.
	self restoreState
		ifNotNil: [ :state | 
			aList := state at: #aList.
			toSkip := state at: #toSkip ].
	aList
		withIndexDo: [ :tcase :index | 
			
			self careTimeBudget 
				ifFalse: [ tcase testMethod: nil  ]
				ifTrue: [
					toSkip = index
				ifTrue: [ tcase testMethod: nil ].
			toSkip > index
				ifFalse: [ toSkip := index.
					self
						saveTheState:
							{(#aList -> aList).
							(#toSkip -> toSkip)} asDictionary.
					self
						saveCrashEvidence:
							{(#testClass -> tcase testClass name).
							(#testMethod -> tcase testMethod)} asDictionary.
					tcase assertionAmplifyBy: assertAmplifier.
					 ] 
					].
			].
	^ aList reject: [ :tcase | tcase testMethod isNil ]
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshots >> eventFile [
	^ FileLocator imageDirectory / '_smallamp_last_event.json'
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshots >> evidenceFile [
	^ FileLocator imageDirectory / '_smallamp_crash_evidence.json'
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshots >> isEventPresent: anEvent [
	^ self eventFile exists
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshots >> resetCurrentState [
	self stateFile exists
		ifTrue: [ self stateFile delete ]
]

{ #category : #private }
SAMainLoopSnapshots >> restoreState [
	self stateFile exists
		ifFalse: [ ^ nil ].
	^ FLMaterializer materializeFromFileNamed: self stateFile basename
]

{ #category : #private }
SAMainLoopSnapshots >> saveCrashEvidence: aDictionary [
	| str |
	str := STONJSON toString: aDictionary.
	self evidenceFile writeStream
		truncate;
		nextPutAll: str;
		close
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshots >> saveEvent: anEvent [
	| str |
	str := STONJSON toString: anEvent.
	(self eventFile) writeStream
		truncate;
		nextPutAll: str;
		close
]

{ #category : #private }
SAMainLoopSnapshots >> saveTheState: anState [
	FLSerializer serialize: anState toFileNamed: self stateFile basename
]

{ #category : #actions }
SAMainLoopSnapshots >> selectionFrom: aList [
	aList ifEmpty: [ ^ {} ].
	^ selection selectSnapshot: aList
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshots >> setupSelection [
	super setupSelection.
	selection
		onBeforeMutant: [ :mutant :index | 
			self saveTheState: {(#toSkip -> index)} asDictionary.
			self
				saveCrashEvidence:
					{(#testClass -> testClass name).
					(#mutant -> mutant asDictionaryObject)} asDictionary ].
	selection
		onMutationEvaluation: [ | toSkip |
			self snapshotPoint: #mutation_testing.
			self restoreState
				ifNil: [ toSkip := 0 ]
				ifNotNil: [ :state | toSkip := state at: #toSkip ].
			toSkip ]
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshots >> snapshot: anEvent [
	anEvent at: #testClass put: testClass name.
	self saveEvent: anEvent.
	Smalltalk snapshot: true andQuit: false.
	^ self isEventPresent: anEvent
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshots >> snapshotPoint: aPoint [
	| anEvent |
	anEvent := Dictionary new
		at: #event put: aPoint;
		at: #testClass put: testClass name;
		yourself.
	self saveEvent: anEvent.
	self resetCurrentState.
	Smalltalk snapshot: true andQuit: false
]

{ #category : #'as yet unclassified' }
SAMainLoopSnapshots >> stateFile [
	^ FileLocator imageDirectory / '_smallamp_last_state.fl'
]
