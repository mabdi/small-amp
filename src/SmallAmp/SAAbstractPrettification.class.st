Class {
	#name : #SAAbstractPrettification,
	#superclass : #Object,
	#instVars : [
		'config'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #initialization }
SAAbstractPrettification class >> initializeWith: aConfig [
	^ self new with: aConfig
]

{ #category : #enumerating }
SAAbstractPrettification class >> select: aPopulation alreadySelected: aPopulationAll [
	^ self new select: aPopulation alreadySelected: aPopulationAll
]

{ #category : #'as yet unclassified' }
SAAbstractPrettification >> prettify: aClass [
	self subclassResponsibility
]

{ #category : #'instance creation' }
SAAbstractPrettification >> with: aConfig [
	self initialize.
	config := aConfig
]
