Class {
	#name : #SAAbstractSelection,
	#superclass : #Object,
	#instVars : [
		'config',
		'uncovered'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SAAbstractSelection class >> defaultOracleReduction [
	^ SANoOracleReduction 
]

{ #category : #initialization }
SAAbstractSelection class >> initializeWith: aConfig [
	^ self new with: aConfig
]

{ #category : #'as yet unclassified' }
SAAbstractSelection >> allOpenedWindows [
	^ SystemWindow allInstances , GLMSystemWindow allInstances
]

{ #category : #'as yet unclassified' }
SAAbstractSelection >> analysisFor: testClasses targets: targetClasses ignore: aListOfMethods [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SAAbstractSelection >> closeAllWindowsBut: openWindows [
	| actualWindows |
	actualWindows := self allOpenedWindows.
	(actualWindows copyWithoutAll: openWindows) do: #delete
]

{ #category : #'as yet unclassified' }
SAAbstractSelection >> initialAnalysisFor: testClasses targets: targetClasses ignore: aListOfMethods [
	^ self subclassResponsibility 
]

{ #category : #enumerating }
SAAbstractSelection >> select: aPopulation [
	self subclassResponsibility
]

{ #category : #accessing }
SAAbstractSelection >> split: aList page: page [
	| start res end |
	start := 1.
	res := OrderedCollection new.
	[ start < aList size ]
		whileTrue: [ end := start + page - 1 min: aList size.
			res add: ((start to: end) collect: [ :indx | aList at: indx ]).
			start := start + page ].
	^ res
]

{ #category : #accessing }
SAAbstractSelection >> uncovered [
	^ uncovered 
]

{ #category : #accessing }
SAAbstractSelection >> uncovered: alist [ 
	uncovered := alist 
]

{ #category : #'instance creation' }
SAAbstractSelection >> with: aConfig [
	self initialize.
	config := aConfig
]
