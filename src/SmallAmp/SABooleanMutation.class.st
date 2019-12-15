Class {
	#name : #SABooleanMutation,
	#superclass : #SALiteralMutation,
	#category : #'SmallAmp-Helpers'
}

{ #category : #'as yet unclassified' }
SABooleanMutation >> mutateNode: aNode [
	| nodes |
	nodes := OrderedCollection new.
	nodes add: (RBLiteralValueNode value: aNode value not).
	^ nodes
]

{ #category : #'as yet unclassified' }
SABooleanMutation >> myType [
	^ Boolean 
]
