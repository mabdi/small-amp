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
	| nodes |
	nodes := {Character null.
	Character cr.
	Character space.
	Character allByteCharacters atRandom} asOrderedCollection.
	aValue asInteger + 1 < Character maxVal
		ifTrue: [ Character value: aValue asInteger + 1 ].
	aValue asInteger - 1 >=0 ifTrue: [
	Character value: aValue asInteger - 1].
	nodes := (nodes reject: [ :x | x = aValue ])
		collect: [ :q | RBLiteralValueNode value: q ].
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
	nodes := {(aValue + 1).
	(aValue - 1).
	(aValue * 2).
	(aValue / 2) asInteger.
	0} asOrderedCollection.
	nodes := (nodes reject: [ :x | x = aValue ])
		collect: [ :q | RBLiteralValueNode value: q ].
	nodes
		add:
			(RBMessageNode
				receiver: (RBVariableNode named: #SmallInteger)
				selector: #maxVal).
	nodes
		add:
			(RBMessageNode
				receiver: (RBVariableNode named: #SmallInteger)
				selector: #minVal).
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
	nodes := {''.
	(self updateRandom: aValue).
	(self insertRandom: aValue).
	(self removeRandom: aValue).
	self randomString} asOrderedCollection reject: [:s | s = aValue].
	nodes := nodes collect: [ :n | RBLiteralValueNode value: n ].
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
aStr ifEmpty: [ ^ aStr ].
	^ aStr copyWithoutIndex: aStr size atRandom
]

{ #category : #removing }
SALiteralMutator >> updateRandom: aStr [
	aStr ifEmpty: [ ^ aStr ].
	^ aStr copy
		at: aStr size atRandom put: self characterSet atRandom;
		yourself
]
