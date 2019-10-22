Class {
	#name : #NotUsedTempsVisitor,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'tmp_var',
		'used'
	],
	#category : #'Amplification-Helpers'
}

{ #category : #initialization }
NotUsedTempsVisitor >> initialize [
	used := false.
]

{ #category : #accessing }
NotUsedTempsVisitor >> tmp_var: aName [
	tmp_var := aName
]

{ #category : #accessing }
NotUsedTempsVisitor >> used [ ^ used
]

{ #category : #visiting }
NotUsedTempsVisitor >> visitMessageNode: aMessageNode [
	aMessageNode receiver isVariable ifTrue: [ aMessageNode receiver name = tmp_var
		ifTrue: [ used := true ]. ].
	
		super visitMessageNode: aMessageNode
]

{ #category : #visiting }
NotUsedTempsVisitor >> visitVariableNode: aVariableNode [
	(aVariableNode name = tmp_var and: [ aVariableNode isRead ])
		ifTrue: [ used := true ].
	super visitVariableNode: aVariableNode
]
