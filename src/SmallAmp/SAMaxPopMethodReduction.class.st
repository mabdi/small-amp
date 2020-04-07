Class {
	#name : #SAMaxPopMethodReduction,
	#superclass : #SAAbstractMethodReduction,
	#instVars : [
		'pool'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SAMaxPopMethodReduction >> addPopFromPoolTo: aListOfMethods limit: aLimit [
	| newPop |
	pool := pool shuffle.
	newPop := aListOfMethods
		, (self popPool: aLimit - aListOfMethods size).
	^ newPop
]

{ #category : #initialization }
SAMaxPopMethodReduction >> initialize [ 
	pool:= OrderedCollection new
]

{ #category : #accessing }
SAMaxPopMethodReduction >> pool [
	^ pool
]

{ #category : #'as yet unclassified' }
SAMaxPopMethodReduction >> popPool: anInt [
	| res limit |
	limit := {anInt.
	pool size} min.
	res := pool first: limit.
	limit <= pool size
		ifTrue: [ pool := pool copyFrom: limit + 1 to: pool size ].
	^ res
]

{ #category : #'as yet unclassified' }
SAMaxPopMethodReduction >> reduceMethods: aListOfMethods [
	aListOfMethods size >= config maxPop
		ifTrue: [ ^ self setThePopSize: aListOfMethods limit: config maxPop ]
		ifFalse: [ ^ self addPopFromPoolTo: aListOfMethods limit: config maxPop ]
]

{ #category : #'as yet unclassified' }
SAMaxPopMethodReduction >> setThePopSize: aListOfMethods limit: aLimit [
	| newPop shf |
	shf := aListOfMethods shuffle.
	newPop := shf first: aLimit.
	pool addAll: (shf copyFrom: aLimit + 1 to: aListOfMethods size).
	^ newPop
]
