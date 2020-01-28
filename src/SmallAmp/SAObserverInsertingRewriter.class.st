Class {
	#name : #SAObserverInsertingRewriter,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'targetNodes',
		'methodAST'
	],
	#category : #'SmallAmp-Helpers'
}

{ #category : #'instance creation' }
SAObserverInsertingRewriter class >> runWith: aMethodAST [
	^ self new
		  with: aMethodAST;
		  run;
		yourself 
]

{ #category : #initialization }
SAObserverInsertingRewriter >> initialize [
	targetNodes := OrderedCollection new
]

{ #category : #'as yet unclassified' }
SAObserverInsertingRewriter >> insertObservers: aMethod [
	targetNodes
		do: [ :aNode | 
			| idx theReceiver theSelector a b |
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
			self class observer observeException: ex id: ' , idx asString , ']'.
							b := RBParser
								parseExpression:
									'[|smallamp_elapsedTime noObserve| noObserve:=false. smallamp_elapsedTime := Time
		millisecondsToRun: [ [ ' , aNode formattedCode
										,
											' ]
		valueWithin: 999 milliSeconds
		onTimeout: [ self class observer observeTimeOut: 1000 id: '
										, idx asString
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
										, ' ] on: Error do: [ :saERR | self halt ] ] ]'.
							a receiver: b.
							aMethod body statements at: idx put: a ] ] ]
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

{ #category : #initialization }
SAObserverInsertingRewriter >> with: aMethodAST [
	self initialize.
	methodAST := aMethodAST.
]
