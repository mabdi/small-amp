Class {
	#name : #SAResultItem,
	#superclass : #Object,
	#instVars : [
		'failedSelectorInOriginal',
		'minifiedVersions'
	],
	#category : #'SmallAmp-Model'
}

{ #category : #adding }
SAResultItem >> failedSelectorInOriginal [
	^ failedSelectorInOriginal
]

{ #category : #adding }
SAResultItem >> failedSelectorInOriginal: aListOfFaileds [
	failedSelectorInOriginal := aListOfFaileds 
]

{ #category : #accessing }
SAResultItem >> minifiedVersions [
	^ minifiedVersions
]

{ #category : #accessing }
SAResultItem >> minifiedVersions: item [
	minifiedVersions := item
]
