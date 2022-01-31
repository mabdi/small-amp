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

{ #category : #'as yet unclassified' }
SmallAmp class >> <~ aString [
	| string isCommandLine |
	isCommandLine := false.
	string := aString isString
		ifFalse: [ aString asString ]
		ifTrue: [ aString ].
	-1000 to: 1000 do: [ :n | 
	(Smalltalk vm getSystemAttribute: n) ifNotNil: [ :x | 
		(x includesSubstring: ('--',SACommandLineHandler commandName)) ifTrue: [ isCommandLine := true ] ] 
	].
	isCommandLine 
		ifFalse: [ aString traceCr ] 
		ifTrue: [
			Stdio stdout
				nextPutAll: Time nowUTC print24;
				nextPutAll: String space;
				nextPutAll: string;
				lf;
				flush
		]
]

{ #category : #'as yet unclassified' }
SmallAmp class >> assertionsHere: caller for: anObject [
	| ast observation asserts hook hookIndex newCode aMethod |
	aMethod := caller class lookupSelector: caller selector.
	ast := aMethod ast.
	hookIndex := -1.
	hookIndex := ast statements
		findFirst:
			[ :s | s isMessage and: [ s receiver isVariable and: [ s receiver name = self name ] ] ].
	hook := ast statements at: hookIndex.
	observation := anObject
		smallAmpAcceptSerializerVisitor: (SAStateSerializer withDepth: SAConfig default serializationMaxDepth)
		atDepth: 0.
	observation name: (hook arguments at: 2) formattedCode.
	asserts := observation buildAssertions: SAAssertGenerator new.
	asserts
		reverseDo: [ :newNode | ast body addNode: newNode after: hook ].
	ast body removeNode: hook.
	newCode := ast formattedCode.
	Author
		useAuthor: 'SmallAmp'
		during: [ caller class compile: newCode classified: aMethod protocol ]
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
	| dt h |
	aBuilder item: #SmallAmp.
	(aBuilder
		item: #'Open Ui (DrTests)';
		parent: #SmallAmp)
		action: [ dt := DrTests new.
			dt pluginsDropList selectItem: SAMutationPlugin.
			dt openWithSpec ].
	(aBuilder
		item: #'Browse Temp Package';
		parent: #SmallAmp)
		action: [ h:= SAGenericMethods new. h createTempPackage. h defaultTempPackage asPackage browse ].
	(aBuilder
		item: #'Clear temp';
		parent: #SmallAmp) action: [ SAGenericMethods new clearTempClasses ].
	(aBuilder
		item: #'Default config';
		parent: #SmallAmp) action: [ (SAConfig class >> #default) browse ].
	(aBuilder
		item: #'Load recent updates';
		parent: #SmallAmp)
		action: [ IceRepository pullRepoNamed: 'small-amp'.
			self
				inform: 'Updated to: ' , (IceRepository latestCommitIdFor: 'small-amp') ]
]

{ #category : #private }
SmallAmp >> amplify: aTestClass target: targetClasses [

	| sa res totalTime |
	sa := config mainloop
		      with: config
		      for: aTestClass
		      targets: targetClasses.
	totalTime := Time millisecondsToRun: [ res := sa amplify ].
	res totalTime: (Duration milliSeconds: totalTime).
	res saveResultToFileAs: aTestClass asString.
	res amplifiedClass fileOut.
	res amplifiedClassInitial fileOut.
	^ res
]

{ #category : #actions }
SmallAmp >> amplifyAll [

	| res objRes |
	self class
	<~
	('SmallAmp pid: '
	 , (OSPlatform current resultOfCommand: 'echo $PPID')).
	SAGenericMethods new preRunChecks.
	res := SAResult new.
	amplifyList
		do: [ :item | 
			| instance |
			self class
			<~ ('Run instance start: ' , item key name , ', target: '
				 , item value asString).
			[ 
			[ 
			instance := self amplify: item key target: item value.
			objRes := instance asDictionaryObject.
			self class <~ 'Run instance finished successfully.'.
			self class
			<~ ('Run instance finish: ' , item key name , ', improved: '
				 ,
					 ((objRes at: #mutationScoreAfter)
					  - (objRes at: #mutationScoreBefore)) asString , '%').
			res addResult: instance for: item ]
				on: SANoGreenTest , SANoUncovered, SAFlakyMutationTesting 
				do: [ :x | x asString traceCr ] ]
				on: Error
				do: [ :ex | 
					config debug ifTrue: [ ex signal ].
					self class <~ ('Run instance crashed: ' , item key name).
					self class <~ ('Error details:' , ex description).
					self class <~ (String streamContents: [ :stream | 
						 ex signalerContext errorReportOn: stream ]) ] ]
		displayingProgress: [ :item | 'Processing ' , item key name ].
	^ res
]

{ #category : #actions }
SmallAmp >> amplifyEval [
	self class <~ 'Run start.'.
	SAGenericMethods new contextInit.
	self amplifyAll.
	self class <~ 'Run finish.'
]

{ #category : #initialization }
SmallAmp >> initialize [
	amplifyList := OrderedCollection new.
	
]

{ #category : #accessing }
SmallAmp >> initializeWith: aConfig [
	self initialize. 
	config := aConfig.
	
]

{ #category : #adding }
SmallAmp >> testCase: aTestClass [ 
	self testCase: aTestClass targets: aTestClass smallAmpTargetClasses 
]

{ #category : #adding }
SmallAmp >> testCase: aTestClass targets: targetClasses [
	amplifyList add: (aTestClass -> targetClasses)
]
