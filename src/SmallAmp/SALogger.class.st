Class {
	#name : #SALogger,
	#superclass : #Object,
	#instVars : [
		'logs'
	],
	#category : #'SmallAmp-Helpers'
}

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
SALogger >> sumDuration: aTag [
	| s |
	s := 0.
	(logs select: [ :x | x key = aTag ])
		doWithIndex: [ :item :index | 
			s := index odd
				ifTrue: [ s - item value]
				ifFalse: [ s + item value] ].
			^ s
]

{ #category : #accessing }
SALogger >> sums [
	^ self keys collect: [ :k | k -> (self sumDuration: k) ]
]

{ #category : #initialization }
SALogger >> timeTickFor: aTag [
	logs add: aTag -> self timestamp
]

{ #category : #initialization }
SALogger >> timestamp [
	^ (DateAndTime now - DateAndTime unixEpoch) asMilliSeconds
]
