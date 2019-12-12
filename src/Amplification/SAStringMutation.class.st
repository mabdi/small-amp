Class {
	#name : #SAStringMutation,
	#superclass : #SALiteralMutation,
	#category : #'Amplification-Helpers'
}

{ #category : #'recursive descent' }
SAStringMutation >> characterSet [
	^ String
		streamContents: [ :stream | 
			Character alphabet putOn: stream.
			Character alphabet asUppercase putOn: stream.
			'0123456789' putOn: stream.
			'!@#$%^&*(){}\|''";:?/.>,<`~§±' putOn: stream.
			Character space putOn: stream.
			Character cr putOn: stream.
			Character tab putOn: stream ]
]

{ #category : #removing }
SAStringMutation >> insertRandom: aStr [
	| x |
	x := aStr size atRandom.
	^ (aStr copyFrom: 1 to: x) , self characterSet atRandom asString
		, (aStr copyFrom: x + 1 to: aStr size)
]

{ #category : #'as yet unclassified' }
SAStringMutation >> mutateNode: aNode [
	| nodes |
	nodes := OrderedCollection new.
	nodes add: (RBLiteralValueNode value: '').
	nodes
		add: (RBLiteralValueNode value: (self updateRandom: aNode value)).
	nodes
		add: (RBLiteralValueNode value: (self insertRandom: aNode value)).
	nodes
		add: (RBLiteralValueNode value: (self removeRandom: aNode value)).
	nodes add: (RBLiteralValueNode value: self randomString).
	^ nodes
]

{ #category : #'as yet unclassified' }
SAStringMutation >> myType [
	^ ByteString 
]

{ #category : #'as yet unclassified' }
SAStringMutation >> randomString [
	^ (String new: 32)
		collect: [ :each | self characterSet atRandom ]
]

{ #category : #removing }
SAStringMutation >> removeRandom: aStr [
	^ aStr copyWithoutIndex: aStr size atRandom
]

{ #category : #removing }
SAStringMutation >> updateRandom: aStr [
	^ aStr copy at: aStr size atRandom put: self characterSet atRandom;yourself
]
