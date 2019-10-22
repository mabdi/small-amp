Class {
	#name : #DSpotBooleanMutation,
	#superclass : #DSpotASTMutation,
	#category : #'Amplification-Helpers'
}

{ #category : #'as yet unclassified' }
DSpotBooleanMutation >> mutateNode: aNode [
	| nodes |
	nodes := OrderedCollection new.
	nodes add: (RBLiteralValueNode value: aNode value not).
	^ nodes
]

{ #category : #'as yet unclassified' }
DSpotBooleanMutation >> myType [
	^ Boolean 
]
