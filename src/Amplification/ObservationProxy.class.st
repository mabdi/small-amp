Class {
	#name : #ObservationProxy,
	#superclass : #MethodCallProxy,
	#instVars : [
		'observer',
		'insideObject'
	],
	#category : #'Amplification-Helpers'
}

{ #category : #'as yet unclassified' }
ObservationProxy class >> for: aMethod observer: observer inside: anObject [
	^ self new initializeFor: aMethod observer: observer inside: anObject
]

{ #category : #'as yet unclassified' }
ObservationProxy >> findIndexInMethod: node [
	^ node parent statements indexOf: node
	
]

{ #category : #initialization }
ObservationProxy >> initializeFor: aMethod observer: anObserver inside: anObject [
	self initializeFor: aMethod.
	observer := anObserver.
	insideObject := anObject 
]

{ #category : #'as yet unclassified' }
ObservationProxy >> methodNodeFromNode: node [
	| mtd |
	mtd := nil.
	mtd := node parent parent.
	(mtd isKindOf: RBMethodNode)
		ifTrue: [ ^ mtd ]
		ifFalse: [ ^ nil ]
]

{ #category : #testing }
ObservationProxy >> needsToObservation: context node: node [
	| callNode |
	context receiver class = insideObject
		ifFalse: [ ^ false ].
	callNode := (node isKindOf: RBAssignmentNode)
		ifTrue: [ node value ]
		ifFalse: [ node ].
	(callNode receiver isKindOf: RBVariableNode)
		ifFalse: [ ^ false ].	"we dont support nested message calls. reciever must be a variable"
	(self methodNodeFromNode: node) ifNil: [ ^ false ].
	^ true
]

{ #category : #'as yet unclassified' }
ObservationProxy >> observe: aReceiver selector: aSelector args: anArray results: result time: elapsedTime [
	| context node idx returnSelf proxyMethod variableName receiverName |
	
	context := self topContext: thisContext.
	context ifNil: [ ^ false ].
	node := context method sourceNodeForPC: context pc.
	(self needsToObservation: context node: node)
		ifFalse: [ ^ false ].
	idx := self findIndexInMethod: node.
	returnSelf := result == aReceiver.
	proxyMethod := (self methodNodeFromNode: node) selector.
	variableName := self variableName: node.
	receiverName := self receiverName: node.
	variableName == #tmp ifTrue: [ variableName := #tmp asString + idx ].
	observer observe: aReceiver name: receiverName id: idx.
	observer
		observeResult: result
		receiver: aReceiver
		selector: aSelector
		name: variableName
		id: idx.
	^ true
]

{ #category : #'as yet unclassified' }
ObservationProxy >> observeException: exception [
	| context node idx proxyMethod |
	context := self topContext: thisContext.
	context ifNil: [ ^ false ].
	node := context method sourceNodeForPC: context pc.
	(self needsToObservation: context node: node)
		ifFalse: [ ^ false ].
	idx := self findIndexInMethod: node.
	proxyMethod := (self methodNodeFromNode: node) selector.
	observer observeException: exception id: idx.
	^ true
]

{ #category : #'as yet unclassified' }
ObservationProxy >> receiverName: node [
	(node parent isKindOf: RBAssignmentNode)
		ifTrue: [ ^ node value receiver name ]
		ifFalse: [ ^ node receiver name ]
]

{ #category : #'changing suspended state' }
ObservationProxy >> run: aSelector with: anArray in: aReceiver [
	| result elapsedTime |
	[ elapsedTime := Time
		millisecondsToRun: [ result := aReceiver withArgs: anArray executeMethod: method ].
	self
		observe: aReceiver
		selector: aSelector
		args: anArray
		results: result
		time: elapsedTime.
	^ result ]
		on: Error
		do: [ :ex | 
			(self observeException: ex)
				ifTrue: [ ^ aReceiver ]
				ifFalse: [ ex signal ] ]
]

{ #category : #initialization }
ObservationProxy >> topContext: aContext [
	| context break seen tmpContext |
	context := aContext.
	"break := false.
	seen := false.
	[ break ]
		whileFalse: [ context receiver ifNil: [ break := true ].
			(context receiver isKindOf: insideObject) ifNil: [ break := true ].
			context method = method
				ifTrue: [ seen
						ifTrue: [ ^ nil	loop detected ].
					seen := true ].
			break
				ifFalse: [ context := context sender ] ].
	"
	[ context receiver isNotNil
		and: [ (context receiver isKindOf: insideObject) not ] ]
		whileTrue: [ context := context sender ].

	"[ (context receiver isKindOf: self class)
		or: [ (context receiver isKindOf: BlockClosure)
				and: [ context receiver outerContext receiver isKindOf: self class ] ] ]
		whileTrue: [ context := context sender ]."
	context receiver ifNil: [ ^ nil ].
	
	tmpContext := thisContext.
	[ context == tmpContext ]
		whileFalse: [ tmpContext receiver = SerializerFactory
				ifTrue: [ ^ nil ].
			tmpContext := tmpContext sender ].	"detect loop - object serialize will call target class's methods and the proxy will be executed before the last finishs. find proxy inside a proxy"
	^ context
]

{ #category : #accessing }
ObservationProxy >> variableName: node [
	(node isKindOf: RBAssignmentNode)
		ifTrue: [ ^ node variable name ]
		ifFalse: [ ^ #tmp ]
]
