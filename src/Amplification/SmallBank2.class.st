Class {
	#name : #SmallBank2,
	#superclass : #Object,
	#instVars : [
		'balance'
	],
	#category : #'Amplification-TestsClasses'
}

{ #category : #accessing }
SmallBank2 >> balance [
	^ balance
]

{ #category : #accessing }
SmallBank2 >> deposit: amount [
	amount < 0
		ifTrue: [ Error new signal ].
	balance := balance + amount
]

{ #category : #initialization }
SmallBank2 >> initialize [
	balance := 0
]

{ #category : #accessing }
SmallBank2 >> withdraw: amount [
	balance >= amount
		ifTrue: [ balance := balance - amount ]
		ifFalse: [ Error new signal ]
]
