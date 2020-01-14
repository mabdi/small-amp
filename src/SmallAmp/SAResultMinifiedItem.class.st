Class {
	#name : #SAResultMinifiedItem,
	#superclass : #Object,
	#instVars : [
		'minifiedClass',
		'minifier',
		'analysis'
	],
	#category : #'SmallAmp-Model'
}

{ #category : #accessing }
SAResultMinifiedItem >> analysis [
	^ analysis
]

{ #category : #accessing }
SAResultMinifiedItem >> analysis: anObject [
	analysis := anObject
]

{ #category : #accessing }
SAResultMinifiedItem >> minifiedClass [
	^ minifiedClass
]

{ #category : #accessing }
SAResultMinifiedItem >> minifiedClass: anObject [
	minifiedClass := anObject
]

{ #category : #accessing }
SAResultMinifiedItem >> minifier [
	^ minifier
]

{ #category : #accessing }
SAResultMinifiedItem >> minifier: anObject [
	minifier := anObject
]
