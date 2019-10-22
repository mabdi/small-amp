Class {
	#name : #DSpotCharMutation,
	#superclass : #DSpotASTMutation,
	#category : #'Amplification-Helpers'
}

{ #category : #'as yet unclassified' }
DSpotCharMutation >> mutateNode: aNode [
	| nodes |
	nodes := OrderedCollection new.
	nodes add: (RBLiteralValueNode value: Character null).
	nodes add: (RBLiteralValueNode value: Character cr).
	nodes add: (RBLiteralValueNode value: Character space).
	nodes
		add: (RBLiteralValueNode value: Character allByteCharacters atRandom).
	nodes add: (RBLiteralValueNode value: (Character value: aNode value asInteger + 1)).
	nodes add: (RBLiteralValueNode value: (Character value: aNode value asInteger - 1)).
	^ nodes
]

{ #category : #'as yet unclassified' }
DSpotCharMutation >> myType [
	^ Character 
]
