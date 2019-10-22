Class {
	#name : #ObserverInsertRewriter,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'targetNodes'
	],
	#category : #'Amplification-Helpers'
}

{ #category : #'as yet unclassified' }
ObserverInsertRewriter >> doYourJob: aMethod [
	self visitNode: aMethod.
	self insertObservers: aMethod
]

{ #category : #initialization }
ObserverInsertRewriter >> initialize [
	targetNodes := OrderedCollection new
]

{ #category : #'as yet unclassified' }
ObserverInsertRewriter >> insertObservers: aMethod [
	| i |
	i := 0.
	targetNodes
		do: [ :x | 
			| idx y rcv sel offset |
			idx := aMethod body statements indexOf: x.
			offset := 0.
			rcv := nil.
			sel := nil.
			
			x value class = RBCascadeNode
				ifTrue: [ rcv := (x value messages at: 1) receiver.
					sel := x value messages last selector ].
			x value class = RBMessageNode
				ifTrue: [ rcv := x value receiver.
					sel := x value selector ].
			(rcv isKindOf: RBVariableNode)
				ifTrue: [ i := i + 1.
					y := RBMessageNode
						receiver: (RBSelfNode named: 'self')
						selector: #observe:name:id:
						arguments:
							{rcv.
							(RBLiteralValueNode value: rcv name).
							(RBLiteralValueNode value: i)}.
					
					aMethod body statements add: y afterIndex: idx + offset. offset := offset + 1 ].
			rcv
				ifNotNil: [ i := i + 1.y := RBMessageNode
						receiver: (RBSelfNode named: 'self')
						selector: #observeResult:receiver:selector:name:id:
						arguments:
							{x variable.
							rcv.
							(RBLiteralValueNode value: sel).
							(RBLiteralValueNode value: x variable name).
							(RBLiteralValueNode value: i)}.
					aMethod body statements add: y afterIndex: idx + offset. offset := offset + 1. ] ]
]

{ #category : #accessing }
ObserverInsertRewriter >> targetNodes [
	^ targetNodes
]

{ #category : #visiting }
ObserverInsertRewriter >> visitAssignmentNode: anAssignmentNode [
	
	anAssignmentNode parent parent class = RBMethodNode
		ifTrue: [ targetNodes add: anAssignmentNode ]
]
