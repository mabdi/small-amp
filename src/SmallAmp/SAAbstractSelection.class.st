Class {
	#name : #SAAbstractSelection,
	#superclass : #Object,
	#instVars : [
		'config'
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
SAAbstractSelection >> select: aPopulation uncovered: uncoveredList [
	self subclassResponsibility
]

{ #category : #accessing }
SAAbstractSelection >> uncovered [
	^ self subclassResponsibility 
]

{ #category : #'instance creation' }
SAAbstractSelection >> with: aConfig [
	self initialize.
	config := aConfig
]
