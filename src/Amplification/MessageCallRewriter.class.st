Class {
	#name : #MessageCallRewriter,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'targetNodes',
		'tmpVariables'
	],
	#category : #'Amplification-Helpers'
}

{ #category : #adding }
MessageCallRewriter >> addTemporaryVariables: anInt to: aMethod [
	tmpVariables := (1 to: anInt)
		collect: [ :idx | 'tmp_' , GeneralHelper randomString , idx asString ].
	EvalLog at: #temps put: anInt.
	tmpVariables do: [ :tvar | aMethod body addTemporaryNamed: tvar ]
]

{ #category : #'as yet unclassified' }
MessageCallRewriter >> convertToAssignments: aMethod [
	| idx y i |
	i := 0.
	targetNodes
		do: [ :x | 
			i := i + 1.
			idx := aMethod body statements indexOf: x.
			y := RBAssignmentNode new.
			y variable: (RBVariableNode named: (tmpVariables at: i)).
			y value: x.
			y parent: aMethod body.
			aMethod body statements at: idx put: y ]
]

{ #category : #'as yet unclassified' }
MessageCallRewriter >> doYourJob: aMethod [
	self visitNode: aMethod.
	self addTemporaryVariables: self targetNodes size to: aMethod.
	self convertToAssignments: aMethod.
]

{ #category : #initialization }
MessageCallRewriter >> initialize [ 
	targetNodes := OrderedCollection new
]

{ #category : #accessing }
MessageCallRewriter >> targetNodes [
^targetNodes
]

{ #category : #visiting }
MessageCallRewriter >> visitCascadeNode: aCascadeNode [
	aCascadeNode parent parent class = RBMethodNode
		ifTrue: [ targetNodes add: aCascadeNode  ]
]

{ #category : #visiting }
MessageCallRewriter >> visitMessageNode: aMessageNode [
	aMessageNode parent parent class = RBMethodNode
		ifTrue: [ targetNodes add: aMessageNode  ]
]
