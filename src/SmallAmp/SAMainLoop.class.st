Class {
	#name : #SAMainLoop,
	#superclass : #Object,
	#instVars : [
		'testClass',
		'targetClasses',
		'config',
		'finalResult',
		'initalizeTime'
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

{ #category : #'as yet unclassified' }
SAMainLoop >> careTimeBudget [
	config timeBudget <= 0 ifTrue: [ ^ true ].
	(self timestamp_now - initalizeTime) < config timeBudget ifFalse: [ self timeBudgetFinished. ^false ].
	^ true
]

{ #category : #initialization }
SAMainLoop >> initialize [
	initalizeTime:= self timestamp_now.
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

{ #category : #'as yet unclassified' }
SAMainLoop >> timeBudgetFinished [
	SmallAmp <~ 'timeBudgetFinished'
]

{ #category : #initialization }
SAMainLoop >> timestamp_now [
	^ DateAndTime now asUnixTime
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
