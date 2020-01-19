Class {
	#name : #SAResultItem,
	#superclass : #Object,
	#instVars : [
		'failedSelectorInOriginal',
		'reducedVersions'
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
SAResultItem >> reducedVersions [
	^ reducedVersions
]

{ #category : #accessing }
SAResultItem >> reducedVersions: item [
	reducedVersions := item
]
