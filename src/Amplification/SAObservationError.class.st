Class {
	#name : #SAObservationError,
	#superclass : #SAObservationAbstract,
	#instVars : [
		'theError'
	],
	#category : #'Amplification-Model'
}

{ #category : #'as yet unclassified' }
SAObservationError class >> forError: exception [
	^ self new
		with: exception;
		yourself
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
