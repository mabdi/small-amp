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
		'amplifyList'
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
	self preRunChecks.
	res := SAResult new.
	amplifyList
		do: [ :item | 
			| instance |
			Transcript show: 'Processing ' , item key name.
			[ instance := self amplify: item key target: item value.
			res addResult: instance for: item ]
				on: Error
				do:
					[ :ex | Transcript show: 'Error in processing ' , item key name , ': ' , ex asString ] ]
		displayingProgress: [ :item | 'Processing ' , item key name ].
	^ res
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

{ #category : #adding }
SmallAmp >> testCase: aTestClass [ 
	self testCase: aTestClass targets: aTestClass smallAmpTargetClasses 
]

{ #category : #adding }
SmallAmp >> testCase: aTestClass targets: targetClasses [
	amplifyList add: aTestClass -> targetClasses
]
