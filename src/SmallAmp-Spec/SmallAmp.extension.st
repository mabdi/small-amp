Extension { #name : #SmallAmp }

{ #category : #'*SmallAmp-Spec' }
SmallAmp class >> assertionsFor: anObject [
	| observation node method |
	node := thisContext sender sourceNodeExecuted.
	observation := anObject
		smallAmpAcceptSerializerVisitor: (SAStateSerializer withDepth: SAConfig default serializationMaxDepth)
		atDepth: 0.
	observation name: (node arguments at: 1) formattedCode.
	method := node methodNode.
	SAAssertionDialog
		openOn: observation
		onMerge: [ :text | 
			method body
				replaceNode: node
				withNode: (RBParser parseExpression: text).
			Author
				useAuthor: 'SmallAmp'
				during: [ method methodClass compile: method formattedCode ] ]
]
