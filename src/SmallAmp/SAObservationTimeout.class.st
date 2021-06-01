Class {
	#name : #SAObservationTimeout,
	#superclass : #SAObservationAbstract,
	#instVars : [
		'timeout'
	],
	#category : #'SmallAmp-Model'
}

{ #category : #'as yet unclassified' }
SAObservationTimeout class >> forTimeout: aMilliSec [
	^ self new with: aMilliSec; yourself
]

{ #category : #'as yet unclassified' }
SAObservationTimeout >> buildAssertions: aGenerator [
	active
		ifFalse: [ ^ {} ].
		^ {}	"aGenerator buildAssertionsTimeoutObservation: self"
]

{ #category : #'as yet unclassified' }
SAObservationTimeout >> noHashAsserts [
	^ true
]

{ #category : #accessing }
SAObservationTimeout >> timeout [
^ timeout
]

{ #category : #accessing }
SAObservationTimeout >> with: aMilliSec [ 
	self initialize.
	timeout := aMilliSec 
]
