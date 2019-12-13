Class {
	#name : #SAObservationAbstract,
	#superclass : #Object,
	#instVars : [
		'id',
		'timestamp'
	],
	#category : #'Amplification-Model'
}

{ #category : #accessing }
SAObservationAbstract >> id [
	^ id
]

{ #category : #accessing }
SAObservationAbstract >> id: anObject [
	id := anObject
]

{ #category : #initialization }
SAObservationAbstract >> initialize [
	super initialize.
	timestamp := (DateAndTime now - DateAndTime unixEpoch) asMilliSeconds
]

{ #category : #accessing }
SAObservationAbstract >> timestamp [
	^ timestamp
]
