Class {
	#name : #SmallBank,
	#superclass : #Object,
	#instVars : [
		'balance'
	],
	#category : #'SmallAmp-Example'
}

{ #category : #accessing }
SmallBank >> balance [
	^ balance
]

{ #category : #accessing }
SmallBank >> deposit: amount [
	balance := balance + amount
]

{ #category : #initialization }
SmallBank >> initialize [ 
	balance := 0
]

{ #category : #accessing }
SmallBank >> rand [
	" Flaky detection "
	^ (1 to: 1000) atRandom

]

{ #category : #accessing }
SmallBank >> withdraw: amount [
	balance >= amount
		ifTrue: [ balance := balance - amount ]
]
