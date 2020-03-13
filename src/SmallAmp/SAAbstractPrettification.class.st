Class {
	#name : #SAAbstractPrettification,
	#superclass : #Object,
	#instVars : [
		'config',
		'theClass'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #initialization }
SAAbstractPrettification class >> initializeWith: aConfig [
	^ self new with: aConfig
]

{ #category : #'as yet unclassified' }
SAAbstractPrettification >> prettify [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SAAbstractPrettification >> prettify: aClass [
	theClass := aClass.
	self prettify
]

{ #category : #'instance creation' }
SAAbstractPrettification >> with: aConfig [
	self initialize.
	config := aConfig
]
