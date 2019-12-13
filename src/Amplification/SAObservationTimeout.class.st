Class {
	#name : #SAObservationTimeout,
	#superclass : #SAObservationAbstract,
	#instVars : [
		'timeout'
	],
	#category : #'Amplification-Model'
}

{ #category : #'as yet unclassified' }
SAObservationTimeout class >> forTimeout: aMilliSec [
	^ self new with: aMilliSec; yourself
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
