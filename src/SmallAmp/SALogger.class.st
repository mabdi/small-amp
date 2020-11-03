Class {
	#name : #SALogger,
	#superclass : #Object,
	#instVars : [
		'logs'
	],
	#classInstVars : [
		'debugWatchings'
	],
	#category : #'SmallAmp-Helpers'
}

{ #category : #accessing }
SALogger class >> debugWatchings [
	^ debugWatchings ifNil: [ debugWatchings := OrderedCollection new ]
]

{ #category : #'as yet unclassified' }
SALogger class >> logConsole: aString [
	Stdio stdout
		nextPutAll: Time nowUTC print24;
		nextPutAll: String space;
		nextPutAll: aString;
		lf;
		flush
]

{ #category : #'accessing structure variables' }
SALogger class >> timestamp [
	^ (DateAndTime now - DateAndTime unixEpoch) asMilliSeconds
]

{ #category : #initialization }
SALogger >> initialize [
	
	logs := OrderedCollection new
]

{ #category : #accessing }
SALogger >> keys [ 
	^ (self logs collect: #key) removeDuplicates
]

{ #category : #initialization }
SALogger >> logs [
^logs
]

{ #category : #initialization }
SALogger >> recoredTag: aTag toRun: aBlock [
	self class logConsole: aTag asString.
	
	logs add: aTag -> (Time millisecondsToRun: aBlock)
]

{ #category : #initialization }
SALogger >> sumDuration: aTag [
	^ self summary at: aTag
]

{ #category : #initialization }
SALogger >> summary [
	^ self keys
		collect:
			[ :x | x -> ((logs select: [ :y | y key = x ]) collect: #value) sum ]
]
