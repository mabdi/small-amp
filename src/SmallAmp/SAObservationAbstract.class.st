Class {
	#name : #SAObservationAbstract,
	#superclass : #Object,
	#instVars : [
		'id',
		'timestamp'
	],
	#category : #'SmallAmp-Model'
}

{ #category : #'as yet unclassified' }
SAObservationAbstract >> buildAssertions [
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
