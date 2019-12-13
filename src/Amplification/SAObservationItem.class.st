Class {
	#name : #SAObservationItem,
	#superclass : #Object,
	#instVars : [
		'theClass',
		'theValue',
		'theSerializerType'
	],
	#category : #'Amplification-Model'
}

{ #category : #'instance creation' }
SAObservationItem class >> newForCollection: anObject values: aCollection [
	^ self new
		  theValue: aCollection;
		  theClass: anObject class;
		theSerializerType: #Collection;
		  yourself
]

{ #category : #'instance creation' }
SAObservationItem class >> newForObject: anObject observers: result [
	^ self new
		  theValue: anObject;
		  theClass: anObject class;
		  theSerializerType: #Object;
		  yourself
]

{ #category : #'instance creation' }
SAObservationItem class >> newForPrimitive: anObject [
	^ self new
		  theValue: anObject;
		  theClass: anObject class;
		  theSerializerType: #Primitive;
		  yourself
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
SAObservationItem >> theSerializerType [
	^ theSerializerType
]

{ #category : #accessing }
SAObservationItem >> theSerializerType: anObject [
	theSerializerType := anObject
]

{ #category : #accessing }
SAObservationItem >> theValue [
	^ theValue
]

{ #category : #accessing }
SAObservationItem >> theValue: anObject [
	theValue := anObject
]
