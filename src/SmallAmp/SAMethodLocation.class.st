Class {
	#name : #SAMethodLocation,
	#superclass : #Object,
	#instVars : [
		'filename',
		'startline',
		'endline'
	],
	#category : #'SmallAmp-Model'
}

{ #category : #accessing }
SAMethodLocation >> endline [

	^ endline
]

{ #category : #accessing }
SAMethodLocation >> endline: anObject [

	endline := anObject
]

{ #category : #accessing }
SAMethodLocation >> filename [

	^ filename
]

{ #category : #accessing }
SAMethodLocation >> filename: anObject [

	filename := anObject
]

{ #category : #accessing }
SAMethodLocation >> startline [

	^ startline
]

{ #category : #accessing }
SAMethodLocation >> startline: anObject [

	startline := anObject
]
