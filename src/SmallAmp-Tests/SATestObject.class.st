Class {
	#name : #SATestObject,
	#superclass : #Object,
	#instVars : [
		'field1',
		'field2',
		'privateField'
	],
	#category : #'SmallAmp-Tests'
}

{ #category : #accessing }
SATestObject >> field1 [
	^ field1
]

{ #category : #accessing }
SATestObject >> field1: anObject [
	field1 := anObject
]

{ #category : #accessing }
SATestObject >> field2 [
	^ field2
]

{ #category : #accessing }
SATestObject >> field2: anObject [
	field2 := anObject
]

{ #category : #private }
SATestObject >> privateField [
	^ privateField
]

{ #category : #'as yet unclassified' }
SATestObject >> showError [
	Error signal: 'an error'
]
