Class {
	#name : #SAAbstractSelection,
	#superclass : #Object,
	#instVars : [
		'config',
		'uncovered'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #initialization }
SAAbstractSelection class >> initializeWith: aConfig [
	^ self new with: aConfig
]

{ #category : #'as yet unclassified' }
SAAbstractSelection >> allOpenedWindows [
	^ SystemWindow allInstances , GLMSystemWindow allInstances
]

{ #category : #'as yet unclassified' }
SAAbstractSelection >> closeAllWindowsBut: openWindows [
	| actualWindows |
	actualWindows := self allOpenedWindows.
	(actualWindows copyWithoutAll: openWindows) do: #delete
]

{ #category : #enumerating }
SAAbstractSelection >> select: aPopulation [
	self subclassResponsibility
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
