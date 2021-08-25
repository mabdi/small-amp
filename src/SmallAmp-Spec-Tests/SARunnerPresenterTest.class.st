"
A SARunnerPresenterTest is a test class for testing the behavior of SARunnerPresenter
"
Class {
	#name : #SARunnerPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'presenter'
	],
	#category : #'SmallAmp-Spec-Tests-UI'
}

{ #category : #testing }
SARunnerPresenterTest >> expectedFailures [ 
	^ #(testTestCaseSelectionSetsTheInputField)
]

{ #category : #running }
SARunnerPresenterTest >> setUp [
	super setUp.
	presenter := SARunnerPresenter example.
]

{ #category : #running }
SARunnerPresenterTest >> tearDown [
	presenter delete.
	super tearDown
]

{ #category : #tests }
SARunnerPresenterTest >> testTestCaseSelectionSetsTheInputField [
	presenter testCasesList selectIndex: 1.
	
	self
		assert: presenter testTargetTextInput text
		equals: presenter amplificationConfiguration testCaseConfigurations first suggestTargetClassName.
		
	self assert: presenter testTargetTextInput isEnabled
]
