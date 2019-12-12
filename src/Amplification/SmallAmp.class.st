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
	#category : #'Amplification-Core'
}

{ #category : #example }
SmallAmp class >> example [
	| config result |
	config := SAConfig new
		          iterations: 3;
		          assertionAmplifiers: { SADefaultAssertionAmplifier };
		          inputAmplifiers: { SALiteralInputAmplifier };
		          selections: { SAMutationCoverageSelection };
		          yourself.
	result := (SmallAmp initializeWith: config)
		          testCase: SmallBankTest targets: { SmallBank };
		          testCase: SmallBank2Test targets: { SmallBank2 };
		          amplifyAll
]

{ #category : #initialization }
SmallAmp class >> initializeWith: aConfig [
	^ self new initializeWith: aConfig
]

{ #category : #private }
SmallAmp >> amplify: aTestClass target: targetClasses [
	^ (SAMainLoop with: config for: aTestClass targets: targetClasses)
		  amplify
]

{ #category : #actions }
SmallAmp >> amplifyAll [
	| res |
	res := SAResult new.
	amplifyList
		do: [ :item | 
			res addResult: (self amplify: item key target: item value) for: item ]
		displayingProgress: [ :item | 'Processing ' , item key name ].
	^ res
]

{ #category : #initialization }
SmallAmp >> initialize [
	amplifyList := OrderedCollection  new
]

{ #category : #accessing }
SmallAmp >> initializeWith: aConfig [
	self initialize. 
	config := aConfig.
	
]

{ #category : #adding }
SmallAmp >> testCase: aTestClass targets: targetClasses [
	amplifyList add: aTestClass -> targetClasses
]
