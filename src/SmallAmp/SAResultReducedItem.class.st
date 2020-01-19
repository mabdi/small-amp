Class {
	#name : #SAResultReducedItem,
	#superclass : #Object,
	#instVars : [
		'analysis',
		'reducer',
		'reducedClass'
	],
	#category : #'SmallAmp-Model'
}

{ #category : #accessing }
SAResultReducedItem >> analysis [
	^ analysis
]

{ #category : #accessing }
SAResultReducedItem >> analysis: anObject [
	analysis := anObject
]

{ #category : #accessing }
SAResultReducedItem >> reducedClass [
	^ reducedClass
]

{ #category : #accessing }
SAResultReducedItem >> reducedClass: anObject [
	reducedClass := anObject
]

{ #category : #accessing }
SAResultReducedItem >> reducer [
	^ reducer
]

{ #category : #accessing }
SAResultReducedItem >> reducer: anObject [
	reducer := anObject
]
