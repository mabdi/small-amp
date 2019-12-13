Class {
	#name : #SAObservationItem,
	#superclass : #SAObservationAbstract,
	#instVars : [
		'theClass',
		'theValue',
		'isFlaky',
		'name',
		'observedBy',
		'depth'
	],
	#category : #'Amplification-Model'
}

{ #category : #'instance creation' }
SAObservationItem class >> newForClass: theObjectClass values: aCollection [
	^ self new
		  theValue: aCollection;
		  theClass: theObjectClass;
		  yourself
]

{ #category : #'instance creation' }
SAObservationItem class >> newForClass: theObjectClass values: aCollection atDepth: anInt [
	^ self new 
		  theValue: aCollection;
		  theClass: theObjectClass;
			depth: anInt;  
		yourself
]

{ #category : #accessing }
SAObservationItem >> depth [
	^ depth
]

{ #category : #accessing }
SAObservationItem >> depth: anInt [
	 depth := anInt 
]

{ #category : #accessing }
SAObservationItem >> isFlaky [
	^ isFlaky ifNil: [ isFlaky:= false ]
]

{ #category : #accessing }
SAObservationItem >> isFlaky: aBoolean [
	isFlaky:= aBoolean
]

{ #category : #accessing }
SAObservationItem >> name [
	^ name
]

{ #category : #accessing }
SAObservationItem >> name: anObject [
	name := anObject
]

{ #category : #accessing }
SAObservationItem >> observedBy [
	^ observedBy
]

{ #category : #accessing }
SAObservationItem >> observedBy: anObject [
	observedBy := anObject
]

{ #category : #accessing }
SAObservationItem >> theClass [
	^ theClass
]

{ #category : #accessing }
SAObservationItem >> theClass: anObject [
	theClass := anObject
]

{ #category : #accessing }
SAObservationItem >> theValue [
	^ theValue
]

{ #category : #accessing }
SAObservationItem >> theValue: anObject [
	theValue := anObject
]
