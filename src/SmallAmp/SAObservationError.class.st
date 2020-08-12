Class {
	#name : #SAObservationError,
	#superclass : #SAObservationAbstract,
	#instVars : [
		'theError'
	],
	#category : #'SmallAmp-Model'
}

{ #category : #'as yet unclassified' }
SAObservationError class >> forError: exception [
	^ self new
		with: exception;
		yourself
]

{ #category : #'as yet unclassified' }
SAObservationError >> buildAssertions: aGenerator [
	active ifFalse: [ ^ {  } ].
	^ aGenerator buildAssertionsErrorObservation: self
]

{ #category : #'instance creation' }
SAObservationError >> theError [
	^ theError
]

{ #category : #'instance creation' }
SAObservationError >> with: anException [
	self initialize.
	theError := anException
]
