Class {
	#name : #SAObserverInsertingRewriter,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'targetNodes',
		'methodAST',
		'config'
	],
	#category : #'SmallAmp-Helpers'
}

{ #category : #initialization }
SAObserverInsertingRewriter >> config: aConfig [
	config:= aConfig
]

{ #category : #initialization }
SAObserverInsertingRewriter >> initialize [
	targetNodes := OrderedCollection new
]

{ #category : #'as yet unclassified' }
SAObserverInsertingRewriter >> insertObservers: aMethod [
	| aNode |
	targetNodes
		do: [ :theNode | 
			| idx theReceiver theSelector a b |
			aNode := theNode nodesDo: [:each | each comments: nil]..
			idx := aMethod body statements indexOf: aNode.
			theReceiver := nil.
			theSelector := nil.
			aNode value class = RBCascadeNode
				ifTrue: [ theReceiver := (aNode value messages at: 1) receiver.
					theSelector := aNode value messages last selector ].
			aNode value class = RBMessageNode
				ifTrue: [ theReceiver := aNode value receiver.
					theSelector := aNode value selector ].
			theReceiver
				ifNotNil: [ theReceiver isVariable
						ifTrue: [ a := RBParser
								parseExpression:
									'[]
		on: Error
		do: [ :ex | 
			self class observer observeException: ex id: ' , idx asString
										, '. ^ self ]'.
							b := RBParser
								parseExpression:
									'[|smallamp_elapsedTime noObserve| noObserve:=false. smallamp_elapsedTime := Time
		millisecondsToRun: [ [ ' , aNode formattedCode
										,
											' ]
		valueWithin: ' , config statementTimeOut asString
										,
											' milliSeconds
		onTimeout: [ self class observer observeTimeOut: '
										, config statementTimeOut asString , ' id: ' , idx asString
										,
											'. noObserve:=true  ] ].
	noObserve ifFalse: [ [self class observer observe: '
										, theReceiver formattedCode , ' name: '''
										, theReceiver formattedCode , ''' id: ' , idx asString
										,
											'.
	self class observer observeResult: ' , aNode variable name
										,
											'
		receiver: ' , theReceiver formattedCode
										,
											'
		selector: #' , theSelector asString
										,
											'
		name: #' , aNode variable name
										,
											'
		id: ' , idx asString
										, ' ] on: Error do: [ :saERR | self error: ''checkMe'' ] ] ]'.
							a receiver: b.
							aMethod body statements at: idx put: a ] ] ]
]

{ #category : #initialization }
SAObserverInsertingRewriter >> methodAST: aMethodAST [
	methodAST := aMethodAST
]

{ #category : #'as yet unclassified' }
SAObserverInsertingRewriter >> run [
	self visitNode: methodAST.
	self insertObservers: methodAST
]

{ #category : #accessing }
SAObserverInsertingRewriter >> targetNodes [
	^ targetNodes
]

{ #category : #visiting }
SAObserverInsertingRewriter >> visitAssignmentNode: anAssignmentNode [
	
	anAssignmentNode parent parent class = RBMethodNode
		ifTrue: [ targetNodes add: anAssignmentNode ]
]
