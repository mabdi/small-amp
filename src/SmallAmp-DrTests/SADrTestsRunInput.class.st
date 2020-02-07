Class {
	#name : #SADrTestsRunInput,
	#superclass : #Object,
	#instVars : [
		'testClass',
		'testTarget'
	],
	#category : #'SmallAmp-DrTests'
}

{ #category : #'instance creation' }
SADrTestsRunInput class >> from: testClass [
	^ self new
		testClass: testClass;
		suggestTargetClassName;
		yourself
]

{ #category : #displaying }
SADrTestsRunInput >> displayStringOn: aStream [
	aStream nextPutAll: self testCase name

]

{ #category : #displaying }
SADrTestsRunInput >> icon [ 
	^ self isTargetSet
		ifTrue: [ self targetSetIcon ]
		ifFalse: [ self targetNotSetIcon ]

]

{ #category : #displaying }
SADrTestsRunInput >> isTargetSet [
	^ self testTarget isNotNil
]

{ #category : #accessing }
SADrTestsRunInput >> name [ 
	testClass name
]

{ #category : #accessing }
SADrTestsRunInput >> suggestTargetClassName [
	| c t |
	(self testClass class methodDict includesKey: #targetClasses)
		ifTrue: [ testTarget := self testClass targetClasses.
			^ self ].
	c := self testClass name allButLast: 'Test' size.
	(SmalltalkImage current hasClassNamed: c)
		ifTrue: [ t := SmalltalkImage current classNamed: c ]
		ifFalse: [ ^ self ].
	(t methods anySatisfy: #isAbstract )
		ifTrue: [ t := nil ].
	t ifNotNil: [ testTarget := {t} ]
]

{ #category : #displaying }
SADrTestsRunInput >> targetNotSetIcon [ 
	^ #error
]

{ #category : #displaying }
SADrTestsRunInput >> targetSetIcon [
	^ #glamorousAccept
]

{ #category : #accessing }
SADrTestsRunInput >> testClass [
	^ testClass
]

{ #category : #accessing }
SADrTestsRunInput >> testClass: anObject [
	testClass := anObject
]

{ #category : #accessing }
SADrTestsRunInput >> testTarget [
	^ testTarget
]

{ #category : #accessing }
SADrTestsRunInput >> testTarget: anObject [
	testTarget := anObject
]
