Class {
	#name : #DSpotIntegerMutation,
	#superclass : #DSpotASTMutation,
	#category : #'Amplification-Helpers'
}

{ #category : #'as yet unclassified' }
DSpotIntegerMutation >> mutateNode: aNode [
	| nodes |
	nodes := OrderedCollection new.
	nodes add: (RBLiteralValueNode value: aNode value + 1).
	nodes add: (RBLiteralValueNode value: aNode value - 1).
	nodes add: (RBLiteralValueNode value: aNode value * 2).
	nodes add: (RBLiteralValueNode value: (aNode value / 2) asInteger).
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
	nodes add: (RBLiteralValueNode value: 0).
	^ nodes
]

{ #category : #'as yet unclassified' }
DSpotIntegerMutation >> myType [
	^ Integer
]
