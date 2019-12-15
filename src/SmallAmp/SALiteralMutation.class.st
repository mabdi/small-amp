Class {
	#name : #SALiteralMutation,
	#superclass : #Object,
	#instVars : [
		'operators'
	],
	#category : #'SmallAmp-Helpers'
}

{ #category : #'as yet unclassified' }
SALiteralMutation >> canHandle: aNode [
	^ (aNode isKindOf: RBLiteralValueNode)
		and: [ aNode value isKindOf: self myType ]
]

{ #category : #'as yet unclassified' }
SALiteralMutation >> mutateNode: aNode [
	self operators
		detect: [ :op | op canHandle: aNode ]
		ifFound: [ :op | ^ op mutateNode: aNode ].
		^ {  }
]

{ #category : #'as yet unclassified' }
SALiteralMutation >> myType [
	self subclassResponsibility 
]

{ #category : #accessing }
SALiteralMutation >> operators [
	^ operators ifNil: [ operators := self class subclasses collect: [ :op | op new ] ]
]
