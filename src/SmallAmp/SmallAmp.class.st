"
Amplification initializeWithTests: UUIDGeneratorTests target: {UUIDGenerator}




Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	improvmentAlgorithm:		<Object>
	testClass:		<Object>
	testTarget:		<Object>


    Implementation Points
"
Class {
	#name : #SmallAmp,
	#superclass : #Object,
	#instVars : [
		'config',
		'amplifyList',
		'logsFile'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #example }
SmallAmp class >> example [
	| result |
	result := SmallAmp initializeDefault
		testCase: SmallBankTest targets: {SmallBank};
		testCase: SmallBank2Test targets: {SmallBank2};
		amplifyAll.
	^ result
]

{ #category : #initialization }
SmallAmp class >> initializeDefault [
	^ self new initializeWith: SAConfig default
]

{ #category : #initialization }
SmallAmp class >> initializeWith: aConfig [
	^ self new initializeWith: aConfig
]

{ #category : #'world menu' }
SmallAmp class >> menuCommandOn: aBuilder [
	<worldMenu>
	| dt |
	aBuilder item: #SmallAmp.
	(aBuilder
		item: #'Open Ui (DrTests)';
		parent: #SmallAmp)
		action: [ dt := DrTests new.
			dt pluginsDropList selectItem: SADrTestsPlugin. 
			dt openWithSpec ].
	(aBuilder
		item: #'Browse Temp Package';
		parent: #SmallAmp)
		action: [ SAASTHelper new defaultTempPackage asPackage browse ].
	(aBuilder
		item: #'Clear temp';
		parent: #SmallAmp) action: [ SAASTHelper new clearTempClasses ].
	(aBuilder
		item: #'Default config';
		parent: #SmallAmp) action: [ (SAConfig class >> #default) browse ]
]

{ #category : #private }
SmallAmp >> amplify: aTestClass target: targetClasses [
	| sa |
	sa := SAMainLoop with: config for: aTestClass targets: targetClasses.
	^ config lite
		ifTrue: [ sa amplifyLite  ]
		ifFalse: [ sa amplify ]
]

{ #category : #actions }
SmallAmp >> amplifyAll [
	| res |
	config runSandboxed
		ifTrue: [ ^ self amplifyAllSandboxed ].
	self preRunChecks.
	res := SAResult new.
	self  finalAmplifyList 
		do: [ :item | 
			| instance |
			('Processing ' , item key name) traceCr.
			[ instance := self amplify: item key target: item value.
			res addResult: instance for: item.
			config saveToFile
				ifTrue: [ instance saveResultToFileAs: item key asString.
					instance amplifiedClass fileOut ] ]
				on: Error
				do:
					[ :ex | ('Error in processing ' , item key name , ': ' , ex asString) traceCr ] ]
		displayingProgress: [ :item | 'Processing ' , item key name ].
	^ res
]

{ #category : #actions }
SmallAmp >> amplifyAllSandboxed [
	| res cmd json |
	self preRunChecks.
	res := SAResult new.
	self finalAmplifyList
		do: [ :item | 
			| instance tcase |
			tcase := item key name.
			(FileLocator imageDirectory / (tcase , '.json')) exists
				ifTrue: [
						(FileLocator imageDirectory / (tcase , '.json')) delete ].
			[ cmd := String
				streamContents: [ :stream | 
					stream
						nextPutAll: FileLocator vmBinary pathString;
						nextPutAll: ' ';
						nextPutAll: FileLocator image pathString;
						nextPutAll: ' ';
						nextPutAll: 'smallamp';
						nextPutAll: ' ';
						nextPutAll: '--amp=';
						nextPutAll: tcase;
						nextPutAll: ' ';
						nextPutAll: '--nosave' ].
			OSPlatform current resultOfCommand: cmd.
			(FileLocator imageDirectory / (tcase , '.json')) exists
				ifTrue: [ json := STONJSON
						fromString:
							(FileLocator imageDirectory / (tcase , '.json')) asFileReference
								contents.
					(FileLocator imageDirectory
						/ ((json at: #amplifiedClass) , '.st')) asFileReference fileIn.
					instance := SAResultItem fromDictionaryObject: json.
					res addResult: instance for: item ]
				ifFalse: [ 'unfinished run' traceCr ] ]
				on: Error
				do: [ :ex | 
					self
						traceCr: 'Error in processing ' , item key name , ': ' , ex asString ] ]
		displayingProgress: [ :item | 'Processing ' , item key name ].
	^ res
]

{ #category : #actions }
SmallAmp >> amplifyEval [
	self debugLog: 'Run start.'.
	CompilationContext bytecodeBackend = EncoderForSistaV1
		ifFalse: [ CompilationContext bytecodeBackend: EncoderForSistaV1.
			self debugLog: 'Encoder changed to SistaV1.' ].
	Author fullName
		ifNil: [ Author fullName: 'SmallAmpEval'.
			self debugLog: 'Author set.' ].
	amplifyList do: [ :item | self amplifyEvalItem: item ].
	self debugLog: 'Run finish.'
]

{ #category : #actions }
SmallAmp >> amplifyEvalItem: item [
	| instance className |
	className := item key name asString.
	logsFile := FileLocator imageDirectory / (className , '.log').
	self debugLog: 'Run instance start: ' , className.
	[ instance := self amplify: item key target: item value.
	self debugLog: 'Run instance finished successfully.'.
	self
		debugLog: 'Json saved on ' , (instance saveResultToFileAs: className).
	instance amplifiedClass fileOut.
	self debugLog: 'Amplified class saved.'.
	self debugLog: 'Run instance finish: ' , className ]
		on: Error
		do: [ :x | 
			self debugLog: 'Run instance crashed: ' , className.
			self debugLog: 'Error details:' , x description ].
	logsFile := nil.
]

{ #category : #'as yet unclassified' }
SmallAmp >> applyExclude [
	| exList list |
	(FileLocator imageDirectory / config excludeList) exists
		ifFalse: [ ^ amplifyList ].
	exList := ((FileLocator imageDirectory / config excludeList)
		asFileReference contents splitOn: String lf)
		reject: [ :line | line beginsWith: '#' ].
	list := amplifyList reject: [ :r | exList includes: r key name ].
	config overwrite
		ifFalse: [list := list reject: [ :class | (FileLocator imageDirectory / (class , '.json')) exists ] ].
	^ list
]

{ #category : #'as yet unclassified' }
SmallAmp >> debugLog: aString [
	| string |
	string := aString isString
		ifFalse: [ aString asString ]
		ifTrue: [ aString ].
	Stdio stdout
		nextPutAll: Time nowUTC print24;
		nextPutAll: String space;
		nextPutAll: string;
		lf;
		flush.
	logsFile ifNotNil: 
	[logsFile writeStream
		nextPutAll: Time nowUTC print24;
		nextPutAll: String space;
		nextPutAll: string;
		lf;
		close]
]

{ #category : #'as yet unclassified' }
SmallAmp >> finalAmplifyList [
	config enableExclude
		ifTrue: [ ^ self applyExclude ]
		ifFalse: [ ^ amplifyList ]
]

{ #category : #initialization }
SmallAmp >> initialize [
	amplifyList := OrderedCollection new.
	SALogger debugWatchings removeAll.
	SADefaultAssertionAmplifier timing: SALogger new
]

{ #category : #accessing }
SmallAmp >> initializeWith: aConfig [
	self initialize. 
	config := aConfig.
	
]

{ #category : #actions }
SmallAmp >> preRunChecks [
	CompiledMethod compilerClass compiler compilationContext encoderClass
		= EncoderForSistaV1
		ifFalse:
			[ Warning new signal: 'Change `Bytecode Backend` in setting to `SistaV1`' ]
]

{ #category : #actions }
SmallAmp >> regenerateMethod: aMethodName [
	| sa method |
	amplifyList do: [ :item |
	sa := SAMainLoop with: config for: item key targets: item value.
	method := sa regenerateMethod: aMethodName.
	method ifNotNil: [ ^ method ]
	]
]

{ #category : #adding }
SmallAmp >> testCase: aTestClass [ 
	self testCase: aTestClass targets: aTestClass smallAmpTargetClasses 
]

{ #category : #adding }
SmallAmp >> testCase: aTestClass targets: targetClasses [
	amplifyList add: (aTestClass -> targetClasses)
]
