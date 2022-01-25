Class {
	#name : #SANewChangesDiffVisitor,
	#superclass : #IceTreeVisitor,
	#instVars : [
		'methodsToCommit',
		'newTree'
	],
	#category : #'SmallAmp-Helpers'
}

{ #category : #testing }
SANewChangesDiffVisitor >> initialize [ 
	newTree := OrderedCollection new
]

{ #category : #accessing }
SANewChangesDiffVisitor >> methodsToCommit [

	^ methodsToCommit
]

{ #category : #accessing }
SANewChangesDiffVisitor >> methodsToCommit: anObject [

	methodsToCommit := anObject
]

{ #category : #accessing }
SANewChangesDiffVisitor >> newTree [

	^ newTree
]

{ #category : #visiting }
SANewChangesDiffVisitor >> visitAddition: anIceAddition [

	| isIncluded |
	anIceAddition definition isMethodDefinition ifFalse: [ ^ self ].
	
	isIncluded := methodsToCommit anySatisfy: [ :m | 
		              m selector = anIceAddition definition name and: [ 
			              m methodClass name
			              = anIceAddition definition className ] ].
	isIncluded ifTrue: [ newTree add: currentNode ]
]

{ #category : #visiting }
SANewChangesDiffVisitor >> visitModification: anIceModification [

		
]

{ #category : #visiting }
SANewChangesDiffVisitor >> visitNoModification: anIceNoModification [

	"Nothing with me. Just visit children"

	self visitChildrenOf: currentNode
]

{ #category : #visiting }
SANewChangesDiffVisitor >> visitRemoval: anIceRemoval [
	
]
