Class {
	#name : #DTAmplifyTestCaseCommand,
	#superclass : #DTMiddleListCommand,
	#category : #'DrTests-Amplification'
}

{ #category : #executing }
DTAmplifyTestCaseCommand >> execute [
	"SmallAmpUI openOnTestCases: self selectedItems"
	self flag: #TODO. "The goal of this method is in the comment above."
	"This is the entry point for integrating SmallAmp with DrTests."
	self selectedItems inspect
]

{ #category : #initialization }
DTAmplifyTestCaseCommand >> initialize [
	super initialize.
	self name: 'Amplify test-case'.
	self description: 'Opens the SmallAmp test amplification tool.'
]
