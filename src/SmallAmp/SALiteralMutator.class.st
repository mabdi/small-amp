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
	aNode statements
		ifNotEmpty: [ toRepeat := aNode statements first copy.
			nodes
				add:
					(RBArrayNode statements: (aNode statements collect: [ :s | toRepeat ])) ].
	nodes
		add:
			(RBArrayNode
				statements: (aNode statements collect: [ :s | RBLiteralValueNode value: nil ])).
	ns := (aNode statements collect: [ :s | s copy ]) asOrderedCollection.
	ns add: (RBLiteralValueNode value: nil).
	nodes add: (RBArrayNode statements: ns).
	^ (nodes reject: [ :s | s = aNode ]) removeDuplicates
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
SALiteralMutator >> mutateFloat: aValue [
	| nodes |
	nodes := {(aValue + 1).
	(aValue - 1).
	(aValue * -1).
	(aValue * 2).
	(aValue / 2) asInteger.
	Float zero.
	Float nan.
	Float infinity.
	Float negativeInfinity.
	Float negativeZero} asOrderedCollection.
	nodes := (nodes reject: [ :x | x = aValue ])
		collect: [ :q | RBLiteralValueNode value: q ].

	"nodes
		add:
			(RBMessageNode
				receiver: (RBVariableNode named: #SmallInteger)
				selector: #maxVal).
	nodes
		add:
			(RBMessageNode
				receiver: (RBVariableNode named: #SmallInteger)
				selector: #minVal)."
	^ nodes
]

{ #category : #'as yet unclassified' }
SALiteralMutator >> mutateInteger: aValue [
	| nodes |
	nodes := {(aValue + 1).
	(aValue - 1).
	(aValue * -1).
	(aValue * 2).
	(aValue / 2) asInteger.
	0.
	SmallInteger maxVal.
	SmallInteger minVal} asOrderedCollection.
	nodes := (nodes reject: [ :x | x = aValue ])
		collect: [ :q | RBLiteralValueNode value: q ].

	"nodes
		add:
			(RBMessageNode
				receiver: (RBVariableNode named: #SmallInteger)
				selector: #maxVal).
	nodes
		add:
			(RBMessageNode
				receiver: (RBVariableNode named: #SmallInteger)
				selector: #minVal)."
	^ nodes
]

{ #category : #'as yet unclassified' }
SALiteralMutator >> mutateLiteralArrayNode: aNode [
	| nodes toRepeat ns isByteArray nulVal |
	isByteArray := aNode isForByteArray.
	nulVal := isByteArray
		ifTrue: [ 0 ]
		ifFalse: [ nil ].
	nodes := OrderedCollection new.
	nodes
		add:
			(RBLiteralArrayNode
				startPosition: 0
				contents: {}
				stopPosition: -1
				isByteArray: isByteArray).
	aNode contents
		ifNotEmpty: [ toRepeat := aNode contents first copy.
			nodes
				add:
					(RBLiteralArrayNode
						startPosition: 0
						contents: (aNode contents collect: [ :s | toRepeat ])
						stopPosition: -1
						isByteArray: isByteArray) ].
	nodes
		add:
			(RBLiteralArrayNode
				startPosition: 0
				contents: (aNode contents collect: [ :s | RBLiteralValueNode value: nulVal ])
				stopPosition: -1
				isByteArray: isByteArray).
	ns := (aNode contents collect: [ :s | s copy ]) asOrderedCollection.
	ns add: (RBLiteralValueNode value: nulVal).
	nodes
		add:
			(RBLiteralArrayNode
				startPosition: 0
				contents: ns
				stopPosition: -1
				isByteArray: isByteArray).
	^ (nodes reject: [ :s | s = aNode ]) removeDuplicates
]

{ #category : #'as yet unclassified' }
SALiteralMutator >> mutateNode: aNode [
	aNode isLiteralNode ifFalse: [ ^ {  } ].
	^ aNode value smallAmpMutateWith: self. 
]

{ #category : #'as yet unclassified' }
SALiteralMutator >> mutateNumber: aValue [
	| nodes |
	nodes := {(aValue + 1).
	(aValue - 1).
	(aValue * -1).
	(aValue * 2).
	(aValue / 2).
	0} asOrderedCollection.
	nodes := (nodes reject: [ :x | x = aValue ])
		collect: [ :q | RBLiteralValueNode value: q ].
	^ nodes
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
