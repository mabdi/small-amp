as yet unclassified
observe: aReceiver selector: aSelector args: anArray results: result exception: exception time: elapsedTime
	| context node idx returnSelf proxyMethod variableName receiverName |
	context := self topContext: thisContext.
	node := context method sourceNodeForPC: context pc.
	(self needsToObservation: context node: node)
		ifFalse: [ ^ false ].
	idx := self findIndexInMethod: node.
	returnSelf := result == aReceiver.
	proxyMethod := (self methodNodeFromNode: node) selector.
	variableName := self variableName: node.
	receiverName := self receiverName: node.
	observer
		observe: aReceiver name: receiverName id: idx.
	observer
		observeResult: result
		receiver: aReceiver
		selector: aSelector
		name: variableName
		id: idx