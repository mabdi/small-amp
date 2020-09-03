Class {
	#name : #FakeSmallBank,
	#superclass : #Object,
	#instVars : [
		'balance'
	],
	#category : #'SmallAmp-Tests-Fakes'
}

{ #category : #accessing }
FakeSmallBank >> balance [
	^ balance
]

{ #category : #accessing }
FakeSmallBank >> deposit: amount [
	balance := balance + amount
]

{ #category : #initialization }
FakeSmallBank >> initialize [ 
	balance := 0
]

{ #category : #accessing }
FakeSmallBank >> loadFrom: aBank [
	balance := aBank balance
]

{ #category : #accessing }
FakeSmallBank >> rand [
	" Flaky detection "
	^ (1 to: 1000) atRandom

]

{ #category : #accessing }
FakeSmallBank >> withdraw: amount [
	balance >= amount
		ifTrue: [ balance := balance - amount ]
]
