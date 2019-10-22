Class {
	#name : #DSpotASTMutation,
	#superclass : #Object,
	#instVars : [
		'operators'
	],
	#category : #'Amplification-Helpers'
}

{ #category : #'as yet unclassified' }
DSpotASTMutation >> canHandle: aNode [
	^ (aNode isKindOf: RBLiteralValueNode)
		and: [ aNode value isKindOf: self myType ]
]

{ #category : #'as yet unclassified' }
DSpotASTMutation >> mutateNode: aNode [
	self operators
		detect: [ :op | op canHandle: aNode ]
		ifFound: [ :op | ^ op mutateNode: aNode ].
		^ {  }
]

{ #category : #'as yet unclassified' }
DSpotASTMutation >> myType [
	self subclassResponsibility 
]

{ #category : #accessing }
DSpotASTMutation >> operators [
	^ operators ifNil: [ operators := self class subclasses collect: [ :op | op new ] ]
]
