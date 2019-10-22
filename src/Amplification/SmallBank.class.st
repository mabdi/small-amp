Class {
	#name : #SmallBank,
	#superclass : #Object,
	#instVars : [
		'balance'
	],
	#category : #'Amplification-TestsClasses'
}

{ #category : #accessing }
SmallBank >> balance [
<SmallAmpAccessing>
	^ balance
]

{ #category : #accessing }
SmallBank >> deposit: amount [
	<SmallAmpAction>
	balance := balance + amount
]

{ #category : #initialization }
SmallBank >> initialize [ 
	balance := 0
]

{ #category : #accessing }
SmallBank >> withdraw: amount [
<SmallAmpAction>
	balance >= amount
		ifTrue: [ balance := balance - amount ]
]
