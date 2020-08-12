Class {
	#name : #SAObservationAbstract,
	#superclass : #Object,
	#instVars : [
		'id',
		'timestamp',
		'active'
	],
	#category : #'SmallAmp-Model'
}

{ #category : #accessing }
SAObservationAbstract >> active [
	^ active
]

{ #category : #accessing }
SAObservationAbstract >> active: anObject [
	active := anObject
]

{ #category : #'as yet unclassified' }
SAObservationAbstract >> buildAssertions: aGenerator [
	^ self subclassResponsibility
]

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
	active := true.
	timestamp := (DateAndTime now - DateAndTime unixEpoch) asMilliSeconds
]

{ #category : #testing }
SAObservationAbstract >> isPrimitive [
	^ false
]

{ #category : #testing }
SAObservationAbstract >> isValueObservation [
	^ false
]

{ #category : #accessing }
SAObservationAbstract >> timestamp [
	^ timestamp
]
