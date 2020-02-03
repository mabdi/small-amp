Class {
	#name : #SALogger,
	#superclass : #Object,
	#instVars : [
		'logs'
	],
	#category : #'SmallAmp-Helpers'
}

{ #category : #'accessing structure variables' }
SALogger class >> timestamp [
	^ (DateAndTime now - DateAndTime unixEpoch) asMilliSeconds
]

{ #category : #initialization }
SALogger >> initialize [
	logs := OrderedCollection new.
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
	logs add:
			aTag
				-> (Time millisecondsToRun: aBlock  )
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
