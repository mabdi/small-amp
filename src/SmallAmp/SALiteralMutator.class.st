Class {
	#name : #SALiteralMutator,
	#superclass : #Object,
	#category : #'SmallAmp-Helpers'
}

{ #category : #'recursive descent' }
SALiteralMutator >> characterSet [
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
SALiteralMutator >> insertRandom: aStr [
	| x |
	x := aStr size atRandom.
	^ (aStr copyFrom: 1 to: x) , self characterSet atRandom asString
		, (aStr copyFrom: x + 1 to: aStr size)
]

{ #category : #'as yet unclassified' }
SALiteralMutator >> mutateArrayNode: aNode [
	| nodes toRepeat ns |
	nodes := OrderedCollection new.
	nodes add: (RBArrayNode statements: {}).
	aNode statements ifNotEmpty: [ 
	toRepeat := aNode statements first copy.
	nodes
		add:
			(RBArrayNode statements: (aNode statements collect: [ :s | toRepeat ]))].
	nodes
		add:
			(RBArrayNode
				statements: (aNode statements collect: [ :s | RBLiteralValueNode value: nil ])).
	ns := aNode statements collect: [ :s | s copy ].
	ns add: (RBLiteralValueNode value: nil).
	nodes
		add:
			(RBArrayNode
				statements:
					ns).
	^ nodes
]

{ #category : #'as yet unclassified' }
SALiteralMutator >> mutateCharacter: aValue [
	|nodes|
	nodes := OrderedCollection new.
	nodes add: (RBLiteralValueNode value: Character null).
	nodes add: (RBLiteralValueNode value: Character cr).
	nodes add: (RBLiteralValueNode value: Character space).
	nodes add:
		(RBLiteralValueNode value: Character allByteCharacters atRandom).
	nodes add: (RBLiteralValueNode value:
			 (Character value: aValue asInteger + 1)).
	nodes add: (RBLiteralValueNode value:
			 (Character value: aValue asInteger - 1)).
	^ nodes
]

{ #category : #'as yet unclassified' }
SALiteralMutator >> mutateFalse: aValue [
	| nodes |
	nodes := OrderedCollection new.
	nodes add: (RBLiteralValueNode value: true).
	^ nodes
]

{ #category : #'as yet unclassified' }
SALiteralMutator >> mutateInteger: aValue [
	| nodes |
	nodes := OrderedCollection new.
	nodes add: (RBLiteralValueNode value: aValue + 1).
	nodes add: (RBLiteralValueNode value: aValue - 1).
	nodes add: (RBLiteralValueNode value: aValue * 2).
	nodes add: (RBLiteralValueNode value: (aValue / 2) asInteger).
	nodes add: (RBMessageNode
			 receiver: (RBVariableNode named: #SmallInteger)
			 selector: #maxVal).
	nodes add: (RBMessageNode
			 receiver: (RBVariableNode named: #SmallInteger)
			 selector: #minVal).
	nodes add: (RBLiteralValueNode value: 0).
	^ nodes
]

{ #category : #'as yet unclassified' }
SALiteralMutator >> mutateNode: aNode [
	aNode isLiteralNode ifFalse: [ ^ {  } ].
	^ aNode value smallAmpMutateWith: self. 
]

{ #category : #'as yet unclassified' }
SALiteralMutator >> mutateObject: aValue [
	^ {  }
]

{ #category : #'as yet unclassified' }
SALiteralMutator >> mutateString: aValue [
	| nodes |
	nodes := OrderedCollection new.
	nodes add: (RBLiteralValueNode value: '').
	nodes add:
		(RBLiteralValueNode value: (self updateRandom: aValue)).
	nodes add:
		(RBLiteralValueNode value: (self insertRandom: aValue)).
	nodes add:
		(RBLiteralValueNode value: (self removeRandom: aValue)).
	nodes add: (RBLiteralValueNode value: self randomString).
	^ nodes
]

{ #category : #'as yet unclassified' }
SALiteralMutator >> mutateTrue: aValue [
	| nodes |
	nodes := OrderedCollection new.
	nodes add: (RBLiteralValueNode value: false).
	^ nodes
]

{ #category : #'as yet unclassified' }
SALiteralMutator >> randomString [
	^ (String new: 32)
		collect: [ :each | self characterSet atRandom ]
]

{ #category : #removing }
SALiteralMutator >> removeRandom: aStr [
	^ aStr copyWithoutIndex: aStr size atRandom
]

{ #category : #removing }
SALiteralMutator >> updateRandom: aStr [
	^ aStr copy at: aStr size atRandom put: self characterSet atRandom;yourself
]
