Class {
	#name : #SAResultItem,
	#superclass : #Object,
	#instVars : [
		'generatedTestClass',
		'minifiedTestClass',
		'minifiedAddedTestClass'
	],
	#category : #'SmallAmp-Model'
}

{ #category : #adding }
SAResultItem >> addFailedSelectorInOriginal: aListOfFaileds [
]

{ #category : #adding }
SAResultItem >> addNewTestClass: aGeneratedTestClass [
	
]

{ #category : #accessing }
SAResultItem >> generatedTestClass [
	^ generatedTestClass
]

{ #category : #accessing }
SAResultItem >> generatedTestClass: anObject [
	generatedTestClass := anObject
]

{ #category : #accessing }
SAResultItem >> minifiedAddedTestClass [ ^ minifiedAddedTestClass
]

{ #category : #accessing }
SAResultItem >> minifiedAddedTestClass: aMinifiedAddedTestClass [	
minifiedAddedTestClass:= aMinifiedAddedTestClass 
]

{ #category : #accessing }
SAResultItem >> minifiedTestClass [
	^ minifiedTestClass
]

{ #category : #accessing }
SAResultItem >> minifiedTestClass: anObject [
	minifiedTestClass := anObject
]
