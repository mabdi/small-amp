Class {
	#name : #DSpotStringMutation,
	#superclass : #DSpotASTMutation,
	#category : #'Amplification-Helpers'
}

{ #category : #'recursive descent' }
DSpotStringMutation >> characterSet [
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
DSpotStringMutation >> insertRandom: aStr [
	| x |
	x := aStr size atRandom.
	^ (aStr copyFrom: 1 to: x) , self characterSet atRandom asString
		, (aStr copyFrom: x + 1 to: aStr size)
]

{ #category : #'as yet unclassified' }
DSpotStringMutation >> mutateNode: aNode [
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
DSpotStringMutation >> myType [
	^ ByteString 
]

{ #category : #'as yet unclassified' }
DSpotStringMutation >> randomString [
	^ (String new: 32)
		collect: [ :each | self characterSet atRandom ]
]

{ #category : #removing }
DSpotStringMutation >> removeRandom: aStr [
	^ aStr copyWithoutIndex: aStr size atRandom
]

{ #category : #removing }
DSpotStringMutation >> updateRandom: aStr [
	^ aStr copy at: aStr size atRandom put: self characterSet atRandom;yourself
]
