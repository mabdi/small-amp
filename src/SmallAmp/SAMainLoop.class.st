Class {
	#name : #SAMainLoop,
	#superclass : #Object,
	#instVars : [
		'testClass',
		'targetClasses',
		'config',
		'finalResult'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #'instance creation' }
SAMainLoop class >> with: aConfig for: aTestClass targets: targetClasses [
	^ self new
		  with: aConfig for: aTestClass targets: targetClasses;	
		  yourself
]

{ #category : #actions }
SAMainLoop >> amplify [
	^ self subclassResponsibility  
]

{ #category : #initialization }
SAMainLoop >> initialize [
	finalResult := SAResultItem new.
]

{ #category : #accessing }
SAMainLoop >> targetClasses [
	^ targetClasses
]

{ #category : #accessing }
SAMainLoop >> testClass [
	^ testClass
]

{ #category : #'instance creation' }
SAMainLoop >> with: aConfig for: aTestClass targets: listofTargetClasses [
	self initialize.
	config := aConfig.
	targetClasses := listofTargetClasses.
	testClass := aTestClass.
	finalResult targetClasses: targetClasses.
	finalResult testClass: testClass.
	
]
