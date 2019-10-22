Class {
	#name : #ObserverInsert2Rewriter,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'targetNodes'
	],
	#category : #'Amplification-Helpers'
}

{ #category : #'as yet unclassified' }
ObserverInsert2Rewriter >> doYourJob: aMethod [
	self visitNode: aMethod.
	self insertObservers: aMethod
]

{ #category : #initialization }
ObserverInsert2Rewriter >> initialize [
	targetNodes := OrderedCollection new
]

{ #category : #'as yet unclassified' }
ObserverInsert2Rewriter >> insertObservers: aMethod [
	| i |
	i := 0.
	targetNodes
		do: [ :x | 
			| idx y rcv sel offset a b|
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
				rcv ifNotNil: [ 
				
				
a:= RBParser parseExpression: '[]
		on: Error
		do: [ :ex | 
			self class observer observeException: ex id: ',idx asString,']'.
		
b:= RBParser parseExpression: '[|smallamp_elapsedTime| smallamp_elapsedTime := Time
		millisecondsToRun: [ ', x formattedCode ,' ].
	self class observer observe: ', rcv formattedCode ,' name: ''', rcv formattedCode ,''' id: ',idx asString ,'.
	self class observer observeResult: ',x variable name,'
		receiver: ',rcv  formattedCode,'
		selector: #', sel asString ,'
		name: #',x variable name,'
		id: ',idx asString ,' ]'.
	
a receiver: b.
aMethod body statements at: idx put: a.
			
			
]			
			
			]
]

{ #category : #accessing }
ObserverInsert2Rewriter >> targetNodes [
	^ targetNodes
]

{ #category : #visiting }
ObserverInsert2Rewriter >> visitAssignmentNode: anAssignmentNode [
	
	anAssignmentNode parent parent class = RBMethodNode
		ifTrue: [ targetNodes add: anAssignmentNode ]
]
