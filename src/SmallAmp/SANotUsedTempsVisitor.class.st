Class {
	#name : #SANotUsedTempsVisitor,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'tmp_var',
		'used'
	],
	#category : #'SmallAmp-Helpers'
}

{ #category : #initialization }
SANotUsedTempsVisitor >> initialize [
	used := false.
]

{ #category : #accessing }
SANotUsedTempsVisitor >> tmp_var: aName [
	tmp_var := aName
]

{ #category : #accessing }
SANotUsedTempsVisitor >> used [ ^ used
]

{ #category : #visiting }
SANotUsedTempsVisitor >> visitMessageNode: aMessageNode [
	aMessageNode receiver isVariable ifTrue: [ aMessageNode receiver name = tmp_var
		ifTrue: [ used := true ]. ].
	
		super visitMessageNode: aMessageNode
]

{ #category : #visiting }
SANotUsedTempsVisitor >> visitVariableNode: aVariableNode [
	(aVariableNode name = tmp_var and: [ aVariableNode isRead ])
		ifTrue: [ used := true ].
	super visitVariableNode: aVariableNode
]
