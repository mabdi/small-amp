Class {
	#name : #TestObject,
	#superclass : #Object,
	#instVars : [
		'field1',
		'field2'
	],
	#category : #'SmallAmp-Tests'
}

{ #category : #accessing }
TestObject >> field1 [
	^ field1
]

{ #category : #accessing }
TestObject >> field1: anObject [
	field1 := anObject
]

{ #category : #accessing }
TestObject >> field2 [
	^ field2
]

{ #category : #accessing }
TestObject >> field2: anObject [
	field2 := anObject
]

{ #category : #'as yet unclassified' }
TestObject >> showError [
	Error signal: 'an error'
]
