Class {
	#name : #EvalLog,
	#superclass : #Object,
	#instVars : [
		'loggers'
	],
	#classInstVars : [
		'instance'
	],
	#category : #'Amplification-Helpers'
}

{ #category : #accessing }
EvalLog class >> at: anIdx put: anObj [
	self instance at: anIdx put: anObj
]

{ #category : #accessing }
EvalLog class >> instance [
	^ instance ifNil: [ instance:= self new ]
]

{ #category : #accessing }
EvalLog class >> instanceReset [
	instance := nil
]

{ #category : #accessing }
EvalLog class >> newGeneration [ 
	self instance newGeneration 
]

{ #category : #accessing }
EvalLog class >> tickAt: anIdx [
	self instance tickAt: anIdx 
]

{ #category : #'as yet unclassified' }
EvalLog >> at: anIdx put: anObj [
	(self loggers at: anIdx) last add: anObj
]

{ #category : #initialization }
EvalLog >> initialize [
	loggers := Dictionary new.
	loggers at: #input_amp put: OrderedCollection new.
	loggers at: #assert_amp put: OrderedCollection new.
	loggers at: #selection put: OrderedCollection new.
	loggers at: #time_all put: OrderedCollection new.
	loggers at: #temps put: OrderedCollection new
]

{ #category : #initialization }
EvalLog >> loggers [
	^ loggers
]

{ #category : #initialization }
EvalLog >> newGeneration [
	self loggers
		do: [ :val | val add: OrderedCollection new ]
]

{ #category : #'math functions' }
EvalLog >> sum: anIdx [
   ^ (self loggers at: anIdx) collect: [ :x | x sum ]
]

{ #category : #initialization }
EvalLog >> summary [
	^ {(#input_amp -> (self timeSum: #input_amp)).
	(#assert_amp -> (self timeSum: #assert_amp)).
	(#selection -> (self timeSum: #selection)).
	(#time_all -> (self timeSum: #time_all)).
	(#temps -> (self sum: #temps))} asDictionary
]

{ #category : #'as yet unclassified' }
EvalLog >> tickAt: anIdx [
	self at: anIdx put: GeneralHelper timeTick
]

{ #category : #'math functions' }
EvalLog >> timeSum: anIdx [
	^ (self loggers at: anIdx) collect: [ :x | |s| s:=0.x doWithIndex: [:y :i | i odd ifTrue: [ s := s - y ] ifFalse: [ s:= s+ y ]  ]. s  ] 
]
