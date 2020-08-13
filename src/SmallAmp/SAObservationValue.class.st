Class {
	#name : #SAObservationValue,
	#superclass : #SAObservationAbstract,
	#instVars : [
		'theClass',
		'theValue',
		'isFlaky',
		'name',
		'observedBy',
		'depth'
	],
	#category : #'SmallAmp-Model'
}

{ #category : #'instance creation' }
SAObservationValue class >> newForClass: theObjectClass values: aCollection atDepth: anInt [
	^ self new 
		  theValue: aCollection;
		  theClass: theObjectClass;
			depth: anInt;  
		yourself
]

{ #category : #accessing }
SAObservationValue >> active [
	^ active and: [ parent ifNotNil: [parent active] ifNil: [ true ] ]
]

{ #category : #accessing }
SAObservationValue >> depth [
	^ depth
]

{ #category : #accessing }
SAObservationValue >> depth: anInt [
	 depth := anInt 
]

{ #category : #accessing }
SAObservationValue >> isFlaky [
	^ isFlaky ifNil: [ isFlaky:= false ]
]

{ #category : #accessing }
SAObservationValue >> isFlaky: aBoolean [
	isFlaky:= aBoolean
]

{ #category : #testing }
SAObservationValue >> isValueObservation [
	^ true
]

{ #category : #accessing }
SAObservationValue >> name [
	^ name
]

{ #category : #accessing }
SAObservationValue >> name: anObject [
	name := anObject
]

{ #category : #accessing }
SAObservationValue >> observedBy [
	^ observedBy
]

{ #category : #accessing }
SAObservationValue >> observedBy: anObject [
	observedBy := anObject
]

{ #category : #accessing }
SAObservationValue >> theClass [
	^ theClass
]

{ #category : #accessing }
SAObservationValue >> theClass: anObject [
	theClass := anObject
]

{ #category : #accessing }
SAObservationValue >> theValue [
	^ theValue
]

{ #category : #accessing }
SAObservationValue >> theValue: anObject [
	theValue := anObject
]
